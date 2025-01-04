# spec/factories/ad_spaces.rb
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
