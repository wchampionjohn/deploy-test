require 'rails_helper'

RSpec.describe Deal, type: :model do
  describe 'validations' do
    subject { build(:deal) }

    it { should validate_presence_of(:deal_type) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe 'associations' do
    it { should belong_to(:ad_space) }
    it { should have_many(:deal_buyers) }
    it { should have_many(:impressions) }
  end

  describe 'deal types' do
    it 'supports private_auction type' do
      deal = create(:deal, :private_auction)
      expect(deal.deal_type).to eq('private_auction')
    end

    it 'supports preferred type' do
      deal = create(:deal, :preferred)
      expect(deal.deal_type).to eq('preferred')
    end

    it 'supports public_auction type' do
      deal = create(:deal, :public_auction)
      expect(deal.deal_type).to eq('public_auction')
    end
  end

  describe 'priority ordering' do
    let!(:private_auction_deal) { create(:deal, :private_auction, priority: 1) }
    let!(:preferred_deal) { create(:deal, :preferred, priority: 1) }
    let!(:public_auction_deal) { create(:deal, :public_auction, priority: 1) }

    it 'orders deals by type priority: private_auction > preferred > public_auction' do
      ordered_deals = Deal.by_priority
      expect(ordered_deals.to_a).to eq([
        private_auction_deal,
        preferred_deal,
        public_auction_deal
      ])
    end

    it 'considers priority within same deal type' do
      high_priority_preferred = create(:deal, :preferred, priority: 0)
      ordered_deals = Deal.by_priority.where(deal_type: 'preferred')
      expect(ordered_deals.to_a).to eq([ high_priority_preferred, preferred_deal ])
    end

    it 'considers price as final sorting factor' do
      Deal.delete_all # Ensure clean state
      high_price_preferred = create(:deal, :preferred, priority: 1, price: 20.0)
      low_price_preferred = create(:deal, :preferred, priority: 1, price: 10.0)

      ordered_deals = Deal.by_priority.where(deal_type: 'preferred').to_a
      expect(ordered_deals).to eq([ high_price_preferred, low_price_preferred ])
      expect(ordered_deals.map(&:price)).to eq([ 20.0, 10.0 ])
    end
  end

  describe '#priority_weight' do
    it 'returns correct weight for private_auction' do
      deal = build(:deal, :private_auction)
      expect(deal.priority_weight).to eq(1)
    end

    it 'returns correct weight for preferred' do
      deal = build(:deal, :preferred)
      expect(deal.priority_weight).to eq(2)
    end

    it 'returns correct weight for public_auction' do
      deal = build(:deal, :public_auction)
      expect(deal.priority_weight).to eq(3)
    end
  end
end
