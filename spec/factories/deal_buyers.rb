# spec/factories/deal_buyers.rb
FactoryBot.define do
  factory :deal_buyer do
    deal
    sequence(:uid) { |n| "buyer-#{n}" }
    sequence(:name) { |n| "Buyer #{n}" }
    is_active { true }
    settings { {} }
    contact_email { "buyer@example.com" }
    seat_bid_floor { 2.5 }
  end
end
