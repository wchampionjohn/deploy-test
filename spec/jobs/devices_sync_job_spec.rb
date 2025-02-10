# frozen_string_literal: true

require "rails_helper"

RSpec.describe DevicesSyncJob, type: :job do
  let(:device_fetcher) { instance_double(Lookr::DeviceFetcher) }
  let(:device_layouts_sync_job) { class_double(DeviceLayoutsSyncJob).as_stubbed_const }
  let(:devices_sync_job) { class_double(DevicesSyncJob).as_stubbed_const }
  let(:page) { 1 }
  let(:is_last_page) { false }
  let(:success) { true }
  let(:lookr_devices) { [] }
  let(:error_message) {}
  let(:result) { double(success?: success, devices: lookr_devices, is_last_page?: is_last_page, error_message: error_message) }

  before do
    allow(Lookr::DeviceFetcher).to receive(:new).and_return(device_fetcher)
    allow(device_fetcher).to receive(:execute).and_return(result)
    allow(device_layouts_sync_job).to receive(:perform_later)
  end

  subject { described_class.perform_now }

  context "when Lookr::DeviceFetcher returns success" do
    let(:lookr_devices) { build(:mock_lookr_devices_response, :success).with_10_devices["devices"] }
    context "when 10 devices are fetched" do
      it { expect { subject }.to change { Device.count }.by(10) }

      it do
        expect(device_layouts_sync_job).to receive(:perform_later).with(anything).exactly(10).times
        subject
      end

      context "when 3 devices are already in the database" do
        let(:lookr_devices) { build(:mock_lookr_devices_response, :success).with_10_devices["devices"] }

        before do
          create(:device, lookr_id: lookr_devices[0]["id"])
          create(:device, lookr_id: lookr_devices[1]["id"])
          create(:device, lookr_id: lookr_devices[2]["id"])
        end

        it { expect { subject }.to change { Device.count }.by(7) }
      end
    end

    context "when Lookr::DeviceFetcher returns is not last page" do
      it "enqueues DevicesSyncJob with next page" do
        expect(devices_sync_job).to receive(:perform_later).with(page: page + 1)
        subject
      end
    end

    context "when Lookr::DeviceFetcher returns is last page" do
      let(:is_last_page) { true }

      it "does not enqueue DevicesSyncJob" do
        expect(devices_sync_job).not_to receive(:perform_later)
        subject
      end
    end
  end

  context "when Lookr::DeviceFetcher returns failure" do
    let(:success) { false }

    it { expect { subject }.to change { SystemLog.count }.by(1) }
    it { expect { subject }.to change { SystemLog.error.last&.title }.from(nil).to("批次同步裝置失敗！") }
  end
end

