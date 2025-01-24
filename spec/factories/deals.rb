# spec/factories/deals.rb
# == Schema Information
#
# Table name: deals
#
#  id                                              :bigint           not null, primary key
#  currency(價格幣別)                              :string           default("USD")
#  deal_type(Deal類型: preferred, private_auction) :string
#  end_date(結束日期)                              :datetime
#  is_active(Deal是否啟用)                         :boolean          default(TRUE)
#  name(Deal名稱)                                  :string
#  price(價格(CPM))                                :decimal(10, 4)
#  priority(優先順序)                              :integer
#  settings(Deal設定)                              :jsonb
#  start_date(開始日期)                            :datetime
#  uid(Deal唯一識別碼)                             :string
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  ad_space_id(廣告版位ID)                         :bigint
#
# Indexes
#
#  index_deals_on_ad_space_id  (ad_space_id)
#  index_deals_on_uid          (uid) UNIQUE
#
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
