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
class AdSpace < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :publisher

  has_many :ad_units
  has_many :deals

  # validations ...............................................................
  validates :name, presence: true
  validates :ad_format, presence: true
  validates :floor_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :active, -> { where(is_active: true, status: "active") }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
