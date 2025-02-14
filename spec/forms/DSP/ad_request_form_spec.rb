# frozen_string_literal: true
#
require "rails_helper"

RSpec.describe DSP::AdRequestForm, type: :form do
  describe "Validations" do
    let(:resolution) { { width: 1920, height: 1080 } }

    let(:dt) { Time.new(2025, 2, 11, 14, 30, 0) }
    let(:timestamp) { Time.new(2025, 2, 11, 13, 30, 0) }
    let(:geo) { { lat: 37.7749, lon: -122.4194 } }

    let(:params) do
      {
        ip: "192.168.1.1",
        user_agent: "Mozilla/5.0",
        timestamp: timestamp,
        dt: dt,
        resolution: resolution,
        geo: geo
      }
    end

    let(:device) { FactoryBot.create(:device) }
    let(:subject) { described_class.new(device, params: params) }

    context "when resolution is present and valid" do
      it { expect(subject).to be_valid }
    end

    context "when resolution is not present" do
      let(:resolution) { nil }

      it { expect(subject.save).to be_falsey }
      it { expect { subject.save }.to change { subject.form_errors }.to({
                                                                          resolution: "can't be blank、必須包含正確的 width 與 height 屬性",
                                                                        }) }
    end

    context "when resolution is not valid" do
      let(:resolution) { { width: "not_an_integer", height: "not_an_integer" } }

      it { expect(subject.save).to be_falsey }
      it { expect { subject.save }.to change { subject.form_errors }.to({
                                                                          resolution: "必須包含正確的 width 與 height 屬性",
                                                                        }) }

    end

    context "when screen is not found" do
      it { expect(subject.save).to be_falsey }
      it { expect { subject.save }.to change { subject.form_errors }.to({
                                                                          resolution: "找不到對應的螢幕解析度",
                                                                        }) }
    end

    context "when ad_units are not found" do
      before { device.screens.create(width: 1920, height: 1080) }

      it { expect(subject.save).to be_falsey }
      it { expect { subject.save }.to change { subject.form_errors }.to({
                                                                          base: "screen 沒有任何對應的 ad_unit",
                                                                        }) }
    end

    context "when ad_unit not match" do
      let(:device) { create(:device) }
      let!(:screen) { create(:screen, device: device) }
      let(:ad_space) { create(:ad_space) }

      let!(:ad_unit) { create(:ad_unit, :with_24_7, screen: screen) }

      before do
        ad_unit.ad_unit_time_multipliers.each do |ad_unit_time_multiplier|
          ad_unit_time_multiplier.update(start_time: dt - 6.hour, end_time: dt - 5.hour)
        end
      end

      it { expect(subject.save).to be_falsey }
      it { expect { subject.save }.to change { subject.form_errors }.to({
                                                                          base: "ad units 中沒有符合條件的 ad unit",
                                                                        }) }
    end

    context "success" do
      let(:device) { create(:device) }
      let!(:screen) { create(:screen, device: device) }
      let(:ad_space) { create(:ad_space) }

      let!(:ad_unit) { create(:ad_unit, :with_24_7, screen: screen) }

      it { expect(subject.save).to be_truthy }
      it { expect { subject.save }.to change { AdRequest.count }.by(1) }
      it do
        subject.save
        expect(subject.ad_request.ip_address).to eq(params[:ip])
        expect(subject.ad_request.user_agent).to eq(params[:user_agent])
        expect(subject.ad_request.processed_at).to eq(params[:timestamp])
        expect(subject.ad_request.estimated_display_time).to eq(params[:dt])
        # json 轉出來會變成 string, 所以這邊要stringify_keys
        expect(subject.ad_request.geo_location).to eq(params[:geo].stringify_keys)

        expect(subject.ad_request.ad_unit).to eq(ad_unit)
        expect(subject.ad_request.device).to eq(device)
        expect(subject.ad_request.applied_multiplier).to eq(1.0)
        expect(subject.ad_request.notification_status).to eq("pending")
      end

      # 這邊只要檢查有存入正確的 hash 即可， 詳細的 bid_request 資訊應該是由 OpenRTBBuilder 的測試案例來驗證
      it "include bid_request info" do
        subject.save

        expect(subject.ad_request.bid_request).to_not be_nil
        expect(subject.ad_request.bid_request).to be_a(Hash)
      end

    end

  end
end
