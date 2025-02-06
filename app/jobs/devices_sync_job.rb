# frozen_string_literal: true

class DevicesSyncJob < ApplicationJob
  queue_as :low

  def perform(page: 1)
    device_fetcher = Lookr::DeviceFetcher.new(page: page)

    # 1. fetch devices from Lookr API
    result = device_fetcher.execute
    if result.success?
      result.devices.each do |lookr_device|
        # 2. create or update each device from fetched data
        device = Device.find_or_create_by!(lookr_id: lookr_device["id"]) do |d|
          d.name = lookr_device["name"]
          d.uid = lookr_device["uid"]
          d.platform = lookr_device["platform"]
        end

        # 3. put each device id to queue for fetching device layouts and blocks
        puts "device lookr_id: #{device.lookr_id}"
        DeviceLayoutsSyncJob.perform_now(device.id)
      end

      puts "page: #{page}"
      puts "is_last_page: #{result.is_last_page?}"
      # 4. fetch next page if not last page
      unless result.is_last_page?
        DevicesSyncJob.perform_now(page: page + 1)
      end
    end
  end
end
