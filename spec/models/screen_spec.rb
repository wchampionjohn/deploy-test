# frozen_string_literal: true

# spec/models/screen_spec.rb
# == Schema Information
#
# Table name: screens
#
#  id                                                       :bigint           not null, primary key
#  brightness_level(亮度等級)                               :integer
#  height                                                   :integer
#  is_active(螢幕是否啟用)                                  :boolean          default(TRUE)
#  operational_status(運作狀態: normal, maintenance, error) :string
#  orientation(螢幕方向: portrait, landscape)               :string
#  physical_location(螢幕實體位置描述)                      :string
#  settings(螢幕設定)                                       :jsonb
#  uid(螢幕唯一識別碼)                                      :string
#  width                                                    :integer
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
#  device_id(關聯的裝置ID)                                  :bigint
#
require "rails_helper"

RSpec.describe Screen, type: :model do
  describe "validations" do
    it { should validate_presence_of(:operational_status) }
  end

  describe "associations" do
    it { should belong_to(:device) }
    it { should have_many(:ad_units) }
  end

  describe "status" do
    let(:screen) { create(:screen) }

    it "has valid operational status" do
      expect(screen.operational_status).to eq("normal")
      screen.operational_status = "maintenance"
      expect(screen).to be_valid
      screen.operational_status = "error"
      expect(screen).to be_valid
    end
  end
end
