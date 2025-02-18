# frozen_string_literal: true

require "rails_helper"

RSpec.describe OptimalAdUnitQuery do
  let(:device) { create(:device) }
  let(:screen) { create(:screen, device: device) }
  let(:ad_space_1) { create(:ad_space) }
  let(:ad_space_2) { create(:ad_space) }
  let(:ad_space_3) { create(:ad_space) }

  let!(:ad_unit_1) { create(:ad_unit, :with_24_7, screen: screen, ad_space: ad_space_1) }
  let!(:ad_unit_2) { create(:ad_unit, :with_24_7, screen: screen, ad_space: ad_space_2) }
  let!(:ad_unit_3) { create(:ad_unit, :with_24_7, screen: screen, ad_space: ad_space_3) }
  let(:ad_units) { screen.ad_units }
  let(:private_auction_deal) { build(:deal, :private_auction) }
  let(:private_auction_deal_price_higher) { build(:deal, :private_auction, price: 20) }
  let(:preferred_deal_price_higher) { build(:deal, :preferred, price: 20) }
  let(:preferred_deal) { build(:deal, :preferred) }

  let(:display_time) { Time.new(2025, 2, 11, 14, 30, 0) }

  describe "#call" do
    subject { described_class.new(ad_units, display_time).call }

    context "data preparation" do
      it do
        subject
        expect(ad_units).to include(ad_unit_1, ad_unit_2, ad_unit_3)
      end
    end

    context "when ad_units with out deals" do
      it "returns first ad_unit" do
        expect(subject).to eq(ad_unit_1)
      end
    end

    context "when ad_units include private_auction, preferred, and no deals" do
      before do
        ad_space_1.deals << private_auction_deal
        ad_space_2.deals << preferred_deal
      end

      it "return ad_unit with private_auction deal" do
        expect(subject).to eq(ad_unit_1)
      end

      context "when the private_auction not on the scheduled" do
        before do
          ad_unit_1.ad_unit_time_multipliers.each do |ad_unit_time_multiplier|
            ad_unit_time_multiplier.update(start_time: display_time - 6.hour, end_time: display_time - 5.hour)
          end
        end

        it "return ad_unit with preferred deal" do
          expect(subject).to eq(ad_unit_2)
        end
      end
    end

    context "when ad_units include 2 preferred deals" do
      before do
        ad_space_1.deals << preferred_deal
        ad_space_2.deals << preferred_deal
        ad_space_2.deals << preferred_deal_price_higher
      end

      it "return the price higher preferred deal" do
        expect(subject).to eq(ad_unit_2)
      end
    end

    context "when ad_units include 2 private_auction deals" do
      before do
        ad_space_1.deals << private_auction_deal
        ad_space_2.deals << private_auction_deal
        ad_space_2.deals << private_auction_deal_price_higher
      end

      it "return the price higher private_auction deal" do
        expect(subject).to eq(ad_unit_2)
      end
    end

  end
end
