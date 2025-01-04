# spec/models/screen_spec.rb
require 'rails_helper'

RSpec.describe Screen, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:uid) }
    it { should validate_presence_of(:operational_status) }
  end

  describe 'associations' do
    it { should belong_to(:device) }
    it { should have_many(:ad_units) }
  end

  describe 'status' do
    let(:screen) { create(:screen) }

    it 'has valid operational status' do
      expect(screen.operational_status).to eq('normal')
      screen.operational_status = 'maintenance'
      expect(screen).to be_valid
      screen.operational_status = 'error'
      expect(screen).to be_valid
    end
  end
end
