# frozen_string_literal: true

# spec/factories/ad_spaces.rb
# == Schema Information
#
# Table name: ad_spaces
#
#  id                                         :bigint           not null, primary key
#  ad_format(廣告格式, banner, video, native) :string           not null
#  description(描述)                          :text
#  floor_price(底價)                          :decimal(10, 4)
#  height(高度)                               :integer
#  is_active(是否啟用)                        :boolean          default(FALSE)
#  name(廣告版位名稱)                         :string
#  status(狀態, pending, active, inactive)    :string
#  targeting(目標設定，如：地理、時段等)      :jsonb
#  width(寬度)                                :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  publisher_id(發布商ID)                     :bigint
#
# Indexes
#
#  index_ad_spaces_on_publisher_id_and_name  (publisher_id,name) UNIQUE
#
FactoryBot.define do
  factory :ad_space do
    publisher
    sequence(:name) { |n| "Ad Space #{n}" }
    ad_format { "video" }
    width { 1920 }
    height { 1080 }
    is_active { true }
    floor_price { 150.00 }
    targeting { { location: "Taipei", time_range: "9-18" } }
    status { "active" }
    description { "Premium advertising space" }
  end
end
