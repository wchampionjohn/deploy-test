# frozen_string_literal: true

# spec/factories/ad_units.rb
# == Schema Information
#
# Table name: ad_units
#
#  id                                        :bigint           not null, primary key
#  floor_price(單元特定底價，可覆蓋版位底價) :decimal(10, 4)
#  fps(Frames per second for DOOH displays)  :integer
#  is_active(廣告單元是否啟用)               :boolean          default(TRUE)
#  max_duration(Maximum duration in seconds) :integer
#  min_duration(Minimum duration in seconds) :integer
#  placement(版位放置設定)                   :jsonb
#  qty_ext                                   :jsonb
#  qty_multiplier(廣告單元底價倍率)          :decimal(10, 4)
#  qty_source_type(廣告單元底價來源類型)     :integer          default("unknown")
#  qty_vendor(廣告單元底價來源廠商)          :string
#  settings(其他設定)                        :jsonb
#  size(廣告尺寸, 如: 300x250)               :string
#  supported_formats(支援的廣告格式陣列)     :string           default([]), is an Array
#  unit_type(單元類型, 如: display, video)   :string           not null
#  vast_enabled(是否支援VAST)                :boolean          default(FALSE)
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  ad_space_id(廣告版位ID)                   :bigint
#  screen_id(螢幕ID)                         :bigint
#
FactoryBot.define do
  factory :ad_unit do
    ad_space
    screen
    unit_type { "video" }
    size { "1920x1080" }
    placement { { position: "fullscreen" } }
    is_active { true }
    floor_price { 100.00 }
    vast_enabled { true }
    supported_formats { ["video/mp4", "video/webm", "image/jpeg", "image/png"] }
    settings { { autoplay: true, loop: false } }
    fps { 30 }
    min_duration { 5 }
    max_duration { 30 }

    trait :with_24_7 do

      after :create do |ad_unit|
        (0..6).to_a.each do |day|
          ad_unit.ad_unit_time_multipliers << build(:ad_unit_time_multiplier, day_of_week: day)
        end
      end
    end
  end
end
