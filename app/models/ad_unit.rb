# frozen_string_literal: true

# == Schema Information
#
# Table name: ad_units
#
#  id                                        :bigint           not null, primary key
#  floor_price(單元特定底價，可覆蓋版位底價) :decimal(10, 4)
#  fps(Frames per second for DOOH displays)  :integer
#  is_active(廣告單元是否啟用)               :boolean          default(TRUE)
#  max_duration(Maximum duration in seconds) :integer
#  min_duration(Minimum duration in seconds) :integer
#  placement(版位放置設定)                   :jsonb
#  qty_ext                                   :jsonb
#  qty_multiplier(廣告單元底價倍率)          :decimal(10, 4)
#  qty_source_type(廣告單元底價來源類型)     :integer          default("unknown")
#  qty_vendor(廣告單元底價來源廠商)          :string
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
class AdUnit < ApplicationRecord
  # extends ...................................................................
  enum :qty_source_type, {
    unknown: 0, # 未知來源
    measurement_vendor: 1, # 由測量供應商提供
    publisher: 2, # 由發布商提供
    exchange: 3 # 由交易所提供
  }, default: :unknown

  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_space
  belongs_to :screen

  has_many :ad_requests
  has_many :impressions
  has_many :vast_responses, dependent: :destroy
  has_many :ad_unit_time_multipliers

  # validations ...............................................................
  validates :unit_type, presence: true, if: -> { ad_space.present? && screen.present? }
  # callbacks .................................................................
  # scopes ....................................................................
  scope :active, -> { where(is_active: true) }
  scope :vast_enabled, -> { where(vast_enabled: true) }
  # additional config .........................................................
  delegate :deals, to: :ad_space
  # class methods .............................................................
  # public instance methods ...................................................
  def recent_vast_responses(limit = 10)
    vast_responses.recent.limit(limit)
  end

  def on_scheduled?(display_time)
    ad_unit_time_multipliers.get_by_time(display_time).present?
  end

  # get multiplier for a given time
  def get_multiplier_for_time(display_time)
    return qty_multiplier unless display_time # 如果沒有指定時間，使用預設值

    time_multiplier = ad_unit_time_multipliers.get_by_time(display_time)

    # 如果找到特定時段的 multiplier，使用它，否則使用預設值
    time_multiplier&.multiplier || qty_multiplier
  end

  # get qty_source_type value
  def qty_source_type_value
    AdUnit.qty_source_types[qty_source_type]
  end

  def best_deal
    deals.best_deal
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
