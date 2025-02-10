require 'rails_helper'

RSpec.describe DeviceLayoutsSyncJob, type: :job do
  let(:device_fetcher) { instance_double(Lookr::DeviceFetcher) }
  let(:success) { true }
  let(:error_message) {}
  let(:lookr_device) { {} }
  let(:device) { create(:device) }
  let(:result) { double(success?: success, device: lookr_device, error_message: error_message) }

  subject { described_class.perform_now(device.id) }

  before do
    allow(Lookr::DeviceFetcher).to receive(:new).and_return(device_fetcher)
    allow(device_fetcher).to receive(:execute).and_return(result)
  end

  context "when Lookr::DeviceFetcher returns success" do
    let(:lookr_device) { build(:mock_lookr_device_layouts_response, :with_single_block) }
    it { expect { subject }.to change { device.screens.count }.by(1) }

    context "when response multiple blocks" do
      let(:lookr_device) { build(:mock_lookr_device_layouts_response, :with_multiple_blocks) }
      it { expect { subject }.to change { device.screens.count }.by(2) }
    end

    context "when device has existing screens" do
      before { device.screens.create(width: 1920, height: 1080) }

      it { expect { subject }.to change { device.screens.count }.by(0) }
    end

    context "when device has one existing screen and lookr has 2 different resolution" do
      let(:lookr_device) { build(:mock_lookr_device_layouts_response, :with_multiple_blocks) }
      before { device.screens.create(width: 1028, height: 768) }

      it { expect { subject }.to change { device.screens.count }.from(1).to(2) }
      it { expect { subject }.to change { device.screens.where(width: 1028, height: 768).count }.from(1).to(0) }
      it { expect { subject }.to change { device.screens.where(width: 1920, height: 648).count }.from(0).to(1) }
      it { expect { subject }.to change { device.screens.where(width: 1920, height: 432).count }.from(0).to(1) }
    end
  end

  context "when Lookr::DeviceFetcher returns failure" do
    let(:success) { false }
    it { expect { subject }.to change { SystemLog.count }.by(1) }
    it { expect { subject }.to change { SystemLog.error.last&.title }.from(nil).to("同步裝置 device_id: #{device.id} block 失敗！") }
  end
end
