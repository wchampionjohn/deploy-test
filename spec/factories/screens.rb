# frozen_string_literal: true

# spec/factories/screens.rb
# == Schema Information
#
# Table name: screens
#
#  id                                                       :bigint           not null, primary key
#  brightness_level(亮度等級)                               :integer
#  height                                                   :integer
#  is_active(螢幕是否啟用)                                  :boolean          default(TRUE)
#  operational_status(運作狀態：normal, maintenance, error) :string
#  orientation(螢幕方向：portrait, landscape)               :string
#  physical_location(螢幕實體位置描述)                      :string
#  settings(螢幕設定)                                       :jsonb
#  uid(螢幕唯一識別碼)                                      :string
#  width                                                    :integer
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
#  device_id(關聯的裝置 ID)                                  :bigint
#
FactoryBot.define do
  factory :screen do
    device
    sequence(:uid) { |n| "SCREEN-#{SecureRandom.hex(4)}-#{n}" }
    physical_location { "一樓電梯大廳" }
    orientation { "landscape" }
    brightness_level { 80 }
    operational_status { "normal" }
    is_active { true }
    settings { { refresh_rate: "60hz" } }
    width { 1920 }
    height { 1080 }
  end
end
