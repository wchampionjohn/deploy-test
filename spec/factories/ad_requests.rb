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
