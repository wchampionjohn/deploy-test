# spec/factories/devices.rb
FactoryBot.define do
  factory :device do
    sequence(:uid) { |n| "DEVICE-#{n}" }
    sequence(:name) { |n| "Device #{n}" }
    platform { "Android" }
    properties { { model: "Model X", manufacturer: "ACME" } }
    status { "online" }
    latitude { 25.0330 }
    longitude { 121.5654 }
    is_active { true }
  end
end
