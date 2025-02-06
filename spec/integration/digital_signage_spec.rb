# frozen_string_literal: true

# spec/integration/digital_signage_spec.rb
require "rails_helper"

RSpec.describe "Digital Signage Integration", type: :model do
  let(:publisher) { create(:publisher) }
  let(:device) { create(:device) }
  let(:screen) { create(:screen, device: device) }
  let(:ad_space) { create(:ad_space, publisher: publisher) }
  let(:ad_unit) { create(:ad_unit, screen: screen, ad_space: ad_space) }

  describe "complete digital signage workflow" do
    it "creates and manages digital signage components" do
      # Device and Screen relationship
      expect(device.screens).to include(screen)
      expect(screen.device).to eq(device)

      # Ad Unit relationships
      expect(ad_unit.screen).to eq(screen)
      expect(ad_unit.ad_space).to eq(ad_space)

      # Test status changes
      screen.update(operational_status: "maintenance")
      expect(screen.operational_status).to eq("maintenance")
      expect(Screen.operational).not_to include(screen)
    end
  end

  describe "ad delivery workflow" do
    let(:ad_request) { create(:ad_request, ad_unit: ad_unit) }

    it "handles ad requests and impressions" do
      expect(ad_request.ad_unit).to eq(ad_unit)

      impression = create(:impression,
        ad_unit: ad_unit,
        deal: create(:deal, ad_space: ad_space)
      )

      expect(impression.ad_unit).to eq(ad_unit)
      expect(ad_unit.impressions).to include(impression)
    end
  end
end
