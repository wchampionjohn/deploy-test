# frozen_string_literal: true

# spec/models/device_spec.rb
# == Schema Information
#
# Table name: devices
#
#  id                                             :bigint           not null, primary key
#  is_active(設備是否啟用)                        :boolean          default(TRUE)
#  last_heartbeat(最後心跳時間)                   :datetime
#  latitude(緯度)                                 :float
#  longitude(經度)                                :float
#  name(裝置名稱)                                 :string
#  platform(設備平台, 如: Android, Windows)       :string
#  properties(設備屬性)                           :jsonb
#  status(設備狀態: online, offline, maintenance) :string
#  uid(裝置唯一識別碼)                            :string
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#
# Indexes
#
#  index_devices_on_uid  (uid) UNIQUE
#
require "rails_helper"

RSpec.describe Device, type: :model do
  describe "validations" do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe "associations" do
    it { should have_many(:screens) }
  end

  describe "scopes" do
    let!(:active_device) { create(:device, is_active: true) }
    let!(:inactive_device) { create(:device, is_active: false) }

    it "filters active devices" do
      expect(Device.where(is_active: true)).to include(active_device)
      expect(Device.where(is_active: true)).not_to include(inactive_device)
    end
  end
end
