# frozen_string_literal: true

# spec/models/ad_space_spec.rb
# == Schema Information
#
# Table name: ad_spaces
#
#  id                                         :bigint           not null, primary key
#  ad_format(廣告格式, banner, video, native) :string           not null
#  description(描述)                          :text
#  floor_price(底價)                          :decimal(10, 4)
#  height(高度)                               :integer
#  is_active(是否啟用)                        :boolean          default(FALSE)
#  name(廣告版位名稱)                         :string
#  status(狀態, pending, active, inactive)    :string
#  targeting(目標設定，如：地理、時段等)      :jsonb
#  width(寬度)                                :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  publisher_id(發布商ID)                     :bigint
#
# Indexes
#
#  index_ad_spaces_on_publisher_id_and_name  (publisher_id,name) UNIQUE
#
RSpec.describe AdSpace, type: :model do
  describe "validations" do
    subject { build(:ad_space) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:ad_format) }
    it { should validate_numericality_of(:floor_price).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe "associations" do
    it { should belong_to(:publisher) }
    it { should have_many(:ad_units) }
    it { should have_many(:deals) }
  end

  describe "scopes" do
    let!(:active_space) { create(:ad_space, is_active: true, status: "active") }
    let!(:pending_space) { create(:ad_space, is_active: false, status: "pending") }

    it "filters active ad spaces" do
      expect(AdSpace.active).to include(active_space)
      expect(AdSpace.active).not_to include(pending_space)
    end
  end
end
