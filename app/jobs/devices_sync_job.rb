# frozen_string_literal: true

class DevicesSyncJob < ApplicationJob
  queue_as :low

  def perform(page: 1)
    device_fetcher = Lookr::DeviceFetcher.new(page: page)

    # 1. fetch devices from Lookr API
    result = device_fetcher.execute

    unless result.success?
      SystemLog.error.create!(
        title: "批次同步裝置失敗！",
        body_payload: {
          "page": page,
          "error": result.error_message
        }
      )

      return false
    end

    result.devices.each do |lookr_device|
      # 2. create or update each device from fetched data
      device = Device.find_or_create_by!(lookr_id: lookr_device["id"]) do |d|
        d.name = lookr_device["name"]
        d.uid = lookr_device["uid"]
        d.platform = lookr_device["platform"]
      end

      # 3. put each device id to queue for fetching device layouts and blocks
      DeviceLayoutsSyncJob.perform_later(device.id)
    end

    # 4. fetch next page if not last page
    unless result.is_last_page?
      DevicesSyncJob.perform_later(page: page + 1)
    end
  end
end
