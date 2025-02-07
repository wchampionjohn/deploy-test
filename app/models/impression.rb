# frozen_string_literal: true

# == Schema Information
#
# Table name: impressions
#
#  id                                               :bigint           not null, primary key
#  bid_response(OpenRTB回應內容)                    :jsonb
#  completed_at(完成播放時間)                       :datetime
#  creative_url(素材URL)                            :string
#  duration(素材時長（影片用）)                     :integer
#  revenue(收益金額)                                :decimal(10, 4)
#  started_at(開始播放時間)                         :datetime
#  status(狀態: pending, playing, completed, error) :string
#  tracking_events(VAST追蹤事件記錄)                :jsonb
#  uid(展示唯一識別碼)                              :string
#  created_at                                       :datetime         not null
#  updated_at                                       :datetime         not null
#  ad_unit_id(關聯的廣告單元ID)                     :bigint
#  deal_id(關聯的Deal ID)                           :bigint
#
# Indexes
#
#  index_impressions_on_ad_unit_id  (ad_unit_id)
#  index_impressions_on_deal_id     (deal_id)
#  index_impressions_on_uid         (uid) UNIQUE
#
class Impression < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_unit
  belongs_to :deal, optional: true
  # validations ...............................................................
  validates :revenue, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :publisher_revenue, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :platform_revenue, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # callbacks .................................................................
  before_create :calculate_revenue_distribution
  before_create :update_deal_spent_budget
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def calculate_revenue_distribution
    return unless revenue.present? && deal.present?

    # 記錄當時的佣金比率
    self.commission_rate_snapshot = deal.commission_rate

    # 計算收益分配
    if commission_rate_snapshot.present? && commission_rate_snapshot > 0
      platform_share = (revenue * commission_rate_snapshot / 100).round(4)
      self.platform_revenue = platform_share
      self.publisher_revenue = revenue - platform_share
    else
      self.publisher_revenue = revenue
      self.platform_revenue = 0
    end
  end

  def update_deal_spent_budget
    return unless deal.present? && revenue.present?

    # 更新 deal 的已花費預算
    deal.with_lock do
      new_spent = deal.spent_budget + revenue
      if deal.total_budget.present? && new_spent > deal.total_budget
        raise "Exceeding deal budget: #{deal.id}"
      end
      deal.update!(spent_budget: new_spent)
    end
  end
end
