# spec/factories/ad_units.rb
FactoryBot.define do
  factory :ad_unit do
    ad_space
    screen
    unit_type { "video" }
    size { "1920x1080" }
    placement { { position: "fullscreen" } }
    is_active { true }
    floor_price { 100.00 }
    vast_enabled { true }
    supported_formats { [ "video/mp4", "video/webm" ] }
    settings { { autoplay: true, loop: false } }
  end
end
