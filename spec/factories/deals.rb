# spec/factories/deals.rb
FactoryBot.define do
  factory :deal do
    ad_space
    sequence(:uid) { |n| "DEAL-#{n}" }
    sequence(:name) { |n| "Deal #{n}" }
    deal_type { "preferred" }
    price { 10.0 }
    start_date { Time.current }
    end_date { 1.month.from_now }
    is_active { true }
    settings { { frequency_cap: 5 } }
    priority { 1 }
    currency { "USD" }

    trait :private_auction do
      deal_type { "private_auction" }
      price { 15.0 }
      settings { { frequency_cap: 5, min_bid_floor: 12.0 } }
    end

    trait :preferred do
      deal_type { "preferred" }
      price { 10.0 }
      settings { { frequency_cap: 5 } }
    end

    trait :public_auction do
      deal_type { "public_auction" }
      price { 5.0 }
      settings { { frequency_cap: 10 } }
    end
  end
end
