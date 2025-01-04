# spec/factories/screens.rb
FactoryBot.define do
  factory :screen do
    device
    sequence(:uid) { |n| "SCREEN-#{n}" }
    physical_location { "一樓電梯大廳" }
    orientation { "landscape" }
    resolution { "1920x1080" }
    brightness_level { 80 }
    operational_status { "normal" }
    is_active { true }
    settings { { refresh_rate: "60hz" } }
  end
end
