# frozen_string_literal: true

#
require "ostruct"

FactoryBot.define do
  factory :mock_lookr_device_layouts_response, class: OpenStruct do
    id { 499 }
    name { "lookr Device" }
    layouts { [] }

    trait :with_single_block do
      after(:build) do |instance|
        instance["layouts"] = [
          {
            "width" => 1920,
            "height" => 1080,
            "viewport_width" => 1920,
            "viewport_height" => 1080,
            "offset_x" => 0,
            "offset_y" => 0,
            "blocks" => [
              {
                "x" => 0,
                "y" => 0,
                "width" => 1920,
                "height" => 1080,
                "index" => 0,
                "id" => 1
              }
            ]
          }
        ]
      end
    end

    trait :with_multiple_blocks do
      after(:build) do |instance|
        instance["layouts"] = [
          {
            "width" => 1920,
            "height" => 1080,
            "viewport_width" => 1920,
            "viewport_height" => 1080,
            "offset_x" => 0,
            "offset_y" => 0,
            "blocks" => [
              {
                "x" => 0,
                "y" => 0,
                "width" => 1920,
                "height" => 648,
                "index" => 0,
                "id" => 1
              },
              {
                "x" => 0,
                "y" => 0,
                "width" => 1920,
                "height" => 432,
                "index" => 1,
                "id" => 2
              }
            ]
          }]
      end
    end

    trait :with_duplicated_blocks do
      after(:build) do |instance|
        instance["layouts"] = [
          {
            "width" => 1920,
            "height" => 1080,
            "viewport_width" => 1920,
            "viewport_height" => 1080,
            "offset_x" => 0,
            "offset_y" => 0,
            "blocks" => [
              {
                "x" => 0,
                "y" => 0,
                "width" => 1920,
                "height" => 540,
                "index" => 0,
                "id" => 1
              },
              {
                "x" => 0,
                "y" => 0,
                "width" => 1920,
                "height" => 540,
                "index" => 1,
              }
            ]
          }
        ]
      end
    end
  end
end
