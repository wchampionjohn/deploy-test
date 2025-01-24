# spec/factories/impressions.rb
# == Schema Information
#
# Table name: impressions
#
#  id                                               :bigint           not null, primary key
#  bid_response(OpenRTB回應內容)                    :jsonb
#  completed_at(完成播放時間)                       :datetime
#  creative_url(素材URL)                            :string
#  duration(素材時長（影片用）)                     :integer
#  revenue(收益金額)                                :decimal(10, 4)
#  started_at(開始播放時間)                         :datetime
#  status(狀態: pending, playing, completed, error) :string
#  tracking_events(VAST追蹤事件記錄)                :jsonb
#  uid(展示唯一識別碼)                              :string
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  ad_unit_id(關聯的廣告單元ID)                     :bigint
#  deal_id(關聯的Deal ID)                           :bigint
#
# Indexes
#
#  index_impressions_on_ad_unit_id  (ad_unit_id)
#  index_impressions_on_deal_id     (deal_id)
#  index_impressions_on_uid         (uid) UNIQUE
#
FactoryBot.define do
  factory :impression do
    ad_unit
    deal
    sequence(:uid) { |n| "IMP-#{n}" }
    revenue { 1.50 }
    bid_response { { id: "bid-123", price: 1.50 } }
    creative_url { "https://example.com/ad.mp4" }
    duration { 30 }
    started_at { Time.current }
    completed_at { Time.current + 30.seconds }
    status { "completed" }
    tracking_events { { start: Time.current, complete: Time.current + 30.seconds } }
  end
end
