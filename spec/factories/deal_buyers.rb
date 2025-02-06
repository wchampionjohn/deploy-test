# spec/factories/deal_buyers.rb
# == Schema Information
#
# Table name: deal_buyers
#
#  id                           :bigint           not null, primary key
#  contact_email(聯絡人郵箱)    :string
#  is_active(買家是否啟用)      :boolean          default(TRUE)
#  name(買家名稱)               :string
#  seat_bid_floor(買家特定底價) :decimal(10, 4)
#  settings(買家設定)           :jsonb
#  uid(買家唯一識別碼)          :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  deal_id(關聯的Deal ID)       :bigint
#
# Indexes
#
#  index_deal_buyers_on_deal_id  (deal_id)
#  index_deal_buyers_on_uid      (uid) UNIQUE
#
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
