# frozen_string_literal: true

# sync lookr 的某台裝置的 layouts 所支援的解析度到本地的 screens table
class DeviceLayoutsSyncJob < ApplicationJob
  queue_as :low

  def perform(device_id)
    device = Device.find(device_id)
    device_fetcher = Lookr::DeviceFetcher.new(device_lookr_id: device.lookr_id)
    result = device_fetcher.execute

    unless result.success?
      SystemLog.error.create!(
        title: "同步裝置 device_id: #{device.id} block 失敗！",
        notify: false,
        body_payload: {
          "device_id": device_id,
          "error": result.error_message
        }
      )

      return false
    end

    return true if result.device["layouts"].compact.blank?

    uniq_resolutions = result.device["layouts"].flat_map do |layout|
      layout["blocks"].map do |block|
        block.slice("width", "height").values
      end
    end.uniq

    existing_resolutions = device.screens
                                 .pluck(:width, :height)

    # 刪除目前存在，但 lookr 上不找不到的解析度的 screen
    (existing_resolutions - uniq_resolutions).each do |resolution|
      device.screens
            .where(width: resolution[0], height: resolution[1])
            .destroy_all
    end

    # 新增或修改 lookr 上有，但本地不存在的解析度的 screen
    uniq_resolutions.each do |resolution|
      device.screens
            .find_or_create_by!(width: resolution[0], height: resolution[1])
    end

  end
end
