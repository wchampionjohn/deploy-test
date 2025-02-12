# frozen_string_literal: true

# == Schema Information
#
# Table name: deals
#
#  id                                                      :bigint           not null, primary key
#  auction_type(First Price Auction, Second Price Auction) :string
#  bidfloor(底價)                                          :decimal(10, 4)
#  bidfloorcur(底價幣別)                                   :string
#  commission_rate(佣金比率(%))                            :decimal(5, 2)
#  commission_settings(佣金設定，如最低金額、階梯式佣金等) :jsonb
#  commission_type(佣金類型: visible(顯示), hidden(隱藏))  :string
#  currency(價格幣別)                                      :string           default("USD")
#  deal_type(Deal類型: preferred, private_auction)         :string
#  end_date(結束日期)                                      :datetime
#  is_active(Deal是否啟用)                                 :boolean          default(TRUE)
#  name(Deal名稱)                                          :string
#  price(價格(CPM))                                        :decimal(10, 4)
#  priority(優先順序)                                      :integer
#  settings(Deal設定)                                      :jsonb
#  spent_budget(已花費預算)                                :decimal(15, 4)   default(0.0)
#  start_date(開始日期)                                    :datetime
#  total_budget(總預算金額)                                :decimal(15, 4)
#  uid(Deal唯一識別碼)                                     :string
#  created_at                                              :datetime         not null
#  updated_at                                              :datetime         not null
#  ad_space_id(廣告版位ID)                                 :bigint
#
# Indexes
#
#  index_deals_on_ad_space_id      (ad_space_id)
#  index_deals_on_commission_type  (commission_type)
#  index_deals_on_uid              (uid) UNIQUE
#
require "rails_helper"

RSpec.describe Deal, type: :model do
  describe "validations" do
    subject { build(:deal) }

    it { should validate_presence_of(:deal_type) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid) }
  end

  describe "associations" do
    it { should belong_to(:ad_space) }
    it { should have_many(:deal_buyers) }
    it { should have_many(:impressions) }
  end

  describe "deal types" do
    it "supports private_auction type" do
      deal = create(:deal, :private_auction)
      expect(deal.deal_type).to eq("private_auction")
    end

    it "supports preferred type" do
      deal = create(:deal, :preferred)
      expect(deal.deal_type).to eq("preferred")
    end

    it "supports public_auction type" do
      deal = create(:deal, :public_auction)
      expect(deal.deal_type).to eq("public_auction")
    end
  end

  describe "priority ordering" do
    let!(:private_auction_deal) { create(:deal, :private_auction, priority: 1) }
    let!(:preferred_deal) { create(:deal, :preferred, priority: 1) }
    let!(:public_auction_deal) { create(:deal, :public_auction, priority: 1) }

    it "orders deals by type priority: private_auction > preferred > public_auction" do
      ordered_deals = Deal.by_priority
      expect(ordered_deals.to_a).to eq([
                                         private_auction_deal,
                                         preferred_deal,
                                         public_auction_deal
                                       ])
    end

    it "considers priority within same deal type" do
      high_priority_preferred = create(:deal, :preferred, priority: 0)
      ordered_deals = Deal.by_priority.where(deal_type: "preferred")
      expect(ordered_deals.to_a).to eq([high_priority_preferred, preferred_deal])
    end

    it "considers price as final sorting factor" do
      Deal.delete_all # Ensure clean state
      high_price_preferred = create(:deal, :preferred, priority: 1, price: 20.0)
      low_price_preferred = create(:deal, :preferred, priority: 1, price: 10.0)

      ordered_deals = Deal.by_priority.where(deal_type: "preferred").to_a
      expect(ordered_deals).to eq([high_price_preferred, low_price_preferred])
      expect(ordered_deals.map(&:price)).to eq([20.0, 10.0])
    end
  end

  describe "#priority_weight" do
    it "returns correct weight for private_auction" do
      deal = build(:deal, :private_auction)
      expect(deal.priority_weight).to eq(1)
    end

    it "returns correct weight for preferred" do
      deal = build(:deal, :preferred)
      expect(deal.priority_weight).to eq(2)
    end

    it "returns correct weight for public_auction" do
      deal = build(:deal, :public_auction)
      expect(deal.priority_weight).to eq(3)
    end
  end

  describe "#rank_value" do
    let(:deal) { build(:deal, :private_auction, price: 10) }
    subject { deal.rank_value }
    context "when deal is private_auction, price = 10" do
      it { is_expected.to eq [-1, 10.0] }
    end

    context "when deal is private_auction, price = 20" do
      let(:deal) { build(:deal, :private_auction, price: 20) }
      it { is_expected.to eq [-1, 20.0] }
    end

    context "when deal is preferred, price = 10" do
      let(:deal) { build(:deal, :preferred, price: 10) }
      it { is_expected.to eq [-2, 10.0] }
    end

  end
end
