# frozen_string_literal: true

class DeviceLayoutsSyncJob < ApplicationJob
  queue_as :low

  def perform(device_id)
    device = Device.find(device_id)
    device_fetcher = Lookr::DeviceFetcher.new(device_lookr_id: device.lookr_id)
    result = device_fetcher.execute
    puts "fetched device layouts: #{result.device.inspect}"
  end
end
