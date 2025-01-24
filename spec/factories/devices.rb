# frozen_string_literal: true

# spec/factories/devices.rb
# == Schema Information
#
# Table name: devices
#
#  id                                             :bigint           not null, primary key
#  is_active(設備是否啟用)                        :boolean          default(TRUE)
#  last_heartbeat(最後心跳時間)                   :datetime
#  latitude(緯度)                                 :float
#  longitude(經度)                                :float
#  name(裝置名稱)                                 :string
#  platform(設備平台, 如: Android, Windows)       :string
#  properties(設備屬性)                           :jsonb
#  status(設備狀態: online, offline, maintenance) :string
#  uid(裝置唯一識別碼)                            :string
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#
# Indexes
#
#  index_devices_on_uid  (uid) UNIQUE
#
FactoryBot.define do
  factory :device do
    sequence(:uid) { |n| "DEVICE-#{n}" }
    sequence(:name) { |n| "Device #{n}" }
    platform { "Android" }
    properties { { model: "Model X", manufacturer: "ACME" } }
    status { "online" }
    latitude { 25.0330 }
    longitude { 121.5654 }
    is_active { true }
  end
end
