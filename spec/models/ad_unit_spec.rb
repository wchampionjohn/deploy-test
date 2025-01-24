# spec/models/ad_unit_spec.rb
# == Schema Information
#
# Table name: ad_units
#
#  id                                        :bigint           not null, primary key
#  floor_price(單元特定底價，可覆蓋版位底價) :decimal(10, 4)
#  is_active(廣告單元是否啟用)               :boolean          default(TRUE)
#  placement(版位放置設定)                   :jsonb
#  settings(其他設定)                        :jsonb
#  size(廣告尺寸, 如: 300x250)               :string
#  supported_formats(支援的廣告格式陣列)     :string           default([]), is an Array
#  unit_type(單元類型, 如: display, video)   :string           not null
#  vast_enabled(是否支援VAST)                :boolean          default(FALSE)
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  ad_space_id(廣告版位ID)                   :bigint
#  screen_id(螢幕ID)                         :bigint
#
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
