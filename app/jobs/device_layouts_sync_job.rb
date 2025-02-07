# frozen_string_literal: true

class DeviceLayoutsSyncJob < ApplicationJob
  queue_as :low

  def perform(device_id)
    device = Device.find(device_id)
    device_fetcher = Lookr::DeviceFetcher.new(device_lookr_id: device.lookr_id)
    result = device_fetcher.execute
    if result.success?
      return true if result.device["layouts"].compact.blank?

      result.device["layouts"].each do |layout|
        device_layout = DeviceLayout.find_or_create_by!(
          device_id: device.id,
          width: layout["width"],
          height: layout["height"],
        )

        layout["blocks"].each do |block|
          DeviceLayoutBlock.find_or_create_by!(device_id: device_id, device_layout_id: device_layout.id, lookr_id: block["id"]) do |dlb|
            dlb.width = block["width"]
            dlb.height = block["height"]
            dlb.index = block["index"]
          end
        end
      end
    end
  end
end
