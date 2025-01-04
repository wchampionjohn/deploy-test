# spec/models/ad_space_spec.rb
RSpec.describe AdSpace, type: :model do
  describe 'validations' do
    subject { build(:ad_space) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:ad_format) }
    it { should validate_numericality_of(:floor_price).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'associations' do
    it { should belong_to(:publisher) }
    it { should have_many(:ad_units) }
    it { should have_many(:deals) }
  end

  describe 'scopes' do
    let!(:active_space) { create(:ad_space, is_active: true, status: 'active') }
    let!(:pending_space) { create(:ad_space, is_active: false, status: 'pending') }

    it 'filters active ad spaces' do
      expect(AdSpace.active).to include(active_space)
      expect(AdSpace.active).not_to include(pending_space)
    end
  end
end
