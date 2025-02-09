# frozen_string_literal: true

#
require "ostruct"

FactoryBot.define do
  factory :mock_lookr_devices_response, class: OpenStruct do
    trait :success do
      with_10_devices {
        {
          "devices" => [
            {
              "id" => 262,
              "uid" => "bbf93aaccab5566c|81d597cd",
              "name" => "MCD ubuntu A1",
              "group_id" => 41,
              "platform" => "desktop",
              "group_name" => "1227 group"
            },
            {
              "id" => 266,
              "uid" => "813f251e4638937d|390f2e0f",
              "name" => "展示会デモ用 3",
              "group_id" => 33,
              "platform" => "desktop",
              "group_name" => "展示会デモ"
            },
            {
              "id" => 305,
              "uid" => "8479d7ed|16c08fe1e9fcc6d5_Lookr190730Lf6d2",
              "name" => "G001",
              "group_id" => nil,
              "platform" => "android",
              "group_name" => nil
            },
            {
              "id" => 355,
              "uid" => "61de84eb35d53f63|906fed2a",
              "name" => "Gary test",
              "group_id" => nil,
              "platform" => "desktop",
              "group_name" => nil
            },
            {
              "id" => 378,
              "uid" => "e5e82fe7005789e9|e04b163b",
              "name" => "EllenPC",
              "group_id" => nil,
              "platform" => "desktop",
              "group_name" => nil
            },
            {
              "id" => 395,
              "uid" => "ce7d0ff3|cc4ec6011697cca3_Lookr190730Lf641",
              "name" => "zack_01",
              "group_id" => nil,
              "platform" => "android",
              "group_name" => nil
            },
            {
              "id" => 398,
              "uid" => "26d48241|b84e383211e7431d_RCF1901020001Lf2d0",
              "name" => "JPTEST2",
              "group_id" => nil,
              "platform" => "android",
              "group_name" => nil
            },
            {
              "id" => 417,
              "uid" => "2416a864|0d568cf498c08ebf_EMULATOR30X0X12X0",
              "name" => "zack_mp",
              "group_id" => nil,
              "platform" => "android",
              "group_name" => nil
            },
            {
              "id" => 428,
              "uid" => "9a0a582f|e5ed3fc52f94ab67_EMULATOR30X0X12X0",
              "name" => "zack_mp3",
              "group_id" => nil,
              "platform" => "android",
              "group_name" => nil
            },
            {
              "id" => 434,
              "uid" => "e4af3554|9fb5310f24d27e89_Y9UYZ7G3T9",
              "name" => "3288B",
              "group_id" => 56,
              "platform" => "android",
              "group_name" => "檔案紀錄 B"
            },
          ],
          "meta" => {
            "total_pages" => 3
          }
        }
      }
    end
  end
end
