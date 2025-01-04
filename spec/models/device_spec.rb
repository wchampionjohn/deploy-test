# spec/models/device_spec.rb
require 'rails_helper'

RSpec.describe Device, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe 'associations' do
    it { should have_many(:screens) }
  end

  describe 'scopes' do
    let!(:active_device) { create(:device, is_active: true) }
    let!(:inactive_device) { create(:device, is_active: false) }

    it 'filters active devices' do
      expect(Device.where(is_active: true)).to include(active_device)
      expect(Device.where(is_active: true)).not_to include(inactive_device)
    end
  end
end
