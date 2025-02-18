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
  #
  # 1. lookr request ad
  # 2. 依據解析度找到 screens
  # 3. 找到每個 screens 的 ad_units
  # 4. 過濾掉時間不符合的 ad_units
  # 5. 找到每個 ad_units 的最佳 deal，(沒有deal就先濾掉，但也有可能不用，看DSP規格再決定)
  # 6. 比較每個最佳 deal，取得 deal 最佳的 ad_unit
  # 7. 最佳的 ad_unit 就是此次的 ad_request 的 ad_unit
  # 8. 送 bid_request 給 DSP 時後帶 deal_id
  def self.find_optimal_ad_unit(duration_time)
    # 過濾掉時間不符合的 ad_units
    scheduled_ad_units = ad_units.active.select do |ad_unit|
      ad_unit.on_scheduled?(duration_time)
    end
    # 找到每個 ad_units 的最佳 deal，(沒有deal就先濾掉，但也有可能不用，看DSP規格再決定)
    ad_units_with_best_deal = scheduled_ad_units.map do |ad_unit|
      {
        ad_unit: ad_unit,
        deal: ad_unit.best_deal
      }
    end

    # 比較每個最佳 deal，取得 deal 最佳的 ad_unit
    sorted_ad_units = ad_units_with_best_deal.sort do |deal_a, deal_b|
      # 比較的兩個 ad_unit 都有 deal，則比較 sorting value
      if deal_a[:deal] && deal_b[:deal]
        deal_a[:deal].rank_value <=> deal_b[:deal].rank_value
      elsif deal_a[:deal]
        -1
      elsif deal_b[:deal]
        1
      else
        0
      end
    end

    sorted_ad_units.first
  end

  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
private
  def set_uid
    loop do
      self.uid ||= SecureRandom.uuid
      break unless Screen.exists?(uid: uid)
    end
  end
end
