# frozen_string_literal: true

# == Schema Information
#
# Table name: screens
#
#  id                                                       :bigint           not null, primary key
#  brightness_level(亮度等級)                               :integer
#  height                                                   :integer
#  is_active(螢幕是否啟用)                                  :boolean          default(TRUE)
#  operational_status(運作狀態: normal, maintenance, error) :string
#  orientation(螢幕方向: portrait, landscape)               :string
#  physical_location(螢幕實體位置描述)                      :string
#  settings(螢幕設定)                                       :jsonb
#  uid(螢幕唯一識別碼)                                      :string
#  width                                                    :integer
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
#  device_id(關聯的裝置ID)                                  :bigint
#
class Screen < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :device

  has_many :ad_units
  # validations ...............................................................
  validates :uid, presence: true, uniqueness: true
  validates :operational_status, presence: true
  validates :orientation, inclusion: { in: %w[portrait landscape] }, allow_nil: true
  validates :width, :height, numericality: { greater_than: 0 }, presence: true

  # callbacks .................................................................
  before_validation :set_uid, on: :create
  # scopes ....................................................................
  scope :active, -> { where(is_active: true) }
  scope :operational, -> { where(operational_status: "normal") }
  # additional config .........................................................
  attribute :operational_status, :string, default: "normal"
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def set_uid
    self.uid ||= SecureRandom.uuid
  end
end
