# spec/models/ad_unit_spec.rb
RSpec.describe AdUnit, type: :model do
  describe 'validations' do
    subject { build(:ad_unit) }

    it { should validate_presence_of(:unit_type) }
  end

  describe 'associations' do
    it { should belong_to(:ad_space) }
    it { should belong_to(:screen) }
    it { should have_many(:ad_requests) }
    it { should have_many(:impressions) }
  end

  describe 'VAST support' do
    let(:ad_unit) { create(:ad_unit, vast_enabled: true) }

    it 'supports VAST when enabled' do
      expect(ad_unit.vast_enabled).to be true
      expect(ad_unit.supported_formats).to include('video/mp4')
    end
  end
end
