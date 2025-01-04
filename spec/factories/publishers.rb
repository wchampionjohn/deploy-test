# spec/factories/publishers.rb
FactoryBot.define do
  factory :publisher do
    sequence(:name) { |n| "Publisher #{n}" }
    sequence(:domain) { |n| "publisher#{n}.com" }
    category { "news" }
    is_active { true }
    settings { { ad_restrictions: [], content_categories: [ "news" ] } }
    contact_email { "contact@example.com" }
    contact_phone { "+886912345678" }
    description { "A premium publisher" }
  end
end
