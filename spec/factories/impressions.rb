# spec/factories/impressions.rb
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
