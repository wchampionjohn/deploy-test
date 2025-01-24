# frozen_string_literal: true

# == Schema Information
#
# Table name: ad_requests
#
#  id                                          :bigint           not null, primary key
#  bid_request(OpenRTB請求內容)                :jsonb
#  error_message(錯誤信息)                     :string
#  geo_location(地理位置信息)                  :jsonb
#  ip_address(請求IP地址)                      :string
#  processed_at(處理時間)                      :datetime
#  status(請求狀態: pending, processed, error) :string
#  uid(廣告請求唯一識別碼)                     :string
#  user_agent(用戶代理信息)                    :jsonb
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  ad_unit_id(關聯的廣告單元ID)                :bigint
#  device_id(關聯的裝置ID)                     :bigint
#
# Indexes
#
#  index_ad_requests_on_ad_unit_id  (ad_unit_id)
#  index_ad_requests_on_device_id   (device_id)
#  index_ad_requests_on_uid         (uid) UNIQUE
#
FactoryBot.define do
  factory :ad_request do
    ad_unit
    device
    sequence(:uid) { |n| "REQUEST-#{n}" }
    ip_address { "192.168.1.1" }
    geo_location { { country: "TW", city: "Taipei" } }
    user_agent { "Mozilla/5.0" }
    bid_request { { id: "bid-123", imp: [] } }
    status { "pending" }
  end
end
