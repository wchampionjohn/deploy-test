# frozen_string_literal: true

# spec/factories/publishers.rb
# == Schema Information
#
# Table name: publishers
#
#  id                                                      :bigint           not null, primary key
#  category(發布商類型, 如：新聞、娛樂等)                  :string
#  commission_settings(佣金設定，如最低金額、階梯式佣金等) :jsonb
#  contact_email(聯絡人信箱)                               :string
#  contact_phone(聯絡人電話)                               :string
#  default_commission_rate(預設佣金比率(%))                :decimal(5, 2)
#  description(發布商描述)                                 :text
#  domain(發布商網域)                                      :string
#  hide_commission(是否隱藏佣金資訊)                       :boolean          default(FALSE)
#  is_active(是否啟用)                                     :boolean          default(FALSE)
#  name(發布商名稱)                                        :string
#  settings(發布商設定，廣告限制、內容分類等)              :jsonb
#  created_at                                              :datetime         not null
#  updated_at                                              :datetime         not null
#
# Indexes
#
#  index_publishers_on_domain  (domain) UNIQUE
#
FactoryBot.define do
  factory :publisher do
    sequence(:name) { |n| "Publisher #{n}" }
    sequence(:domain) { |n| "publisher-#{n}-#{SecureRandom.hex(4)}.com" }
    category { "news" }
    is_active { true }
    settings { { ad_restrictions: [], content_categories: ["news"] } }
    contact_email { "contact@example.com" }
    contact_phone { "+886912345678" }
    description { "A premium publisher" }
  end
end
