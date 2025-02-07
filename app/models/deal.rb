# frozen_string_literal: true

# == Schema Information
#
# Table name: deals
#
#  id                                              :bigint           not null, primary key
#  currency(價格幣別)                              :string           default("USD")
#  deal_type(Deal類型: preferred, private_auction) :string
#  end_date(結束日期)                              :datetime
#  is_active(Deal是否啟用)                         :boolean          default(TRUE)
#  name(Deal名稱)                                  :string
#  price(價格(CPM))                                :decimal(10, 4)
#  priority(優先順序)                              :integer
#  settings(Deal設定)                              :jsonb
#  start_date(開始日期)                            :datetime
#  uid(Deal唯一識別碼)                             :string
#  created_at                                      :datetime         not null
#  updated_at                                      :datetime         not null
#  ad_space_id(廣告版位ID)                         :bigint
#
# Indexes
#
#  index_deals_on_ad_space_id  (ad_space_id)
#  index_deals_on_uid          (uid) UNIQUE
#
class Deal < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  enum :deal_type, {
    private_auction: "private_auction",
    preferred: "preferred",
    public_auction: "public_auction"
  }

  enum :commission_type, {
    visible: "visible",
    hidden: "hidden"
  }
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_space

  has_many :deal_buyers
  has_many :impressions
  # validations ...............................................................
  validates :deal_type, presence: true
  validates :uid, presence: true, uniqueness: true

  validates :commission_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :total_budget, numericality: { greater_than: 0 }, allow_nil: true
  validates :spent_budget, numericality: { greater_than_or_equal_to: 0 }
  validate :spent_budget_cannot_exceed_total_budget

  # callbacks .................................................................
  before_create :set_default_commission_rate
  before_save :ensure_commission_settings_format

  # scopes ....................................................................
  # scope :by_priority, -> { order(priority: :asc) }
  scope :by_priority, -> {
    order(Arel.sql("CASE deal_type
      WHEN 'private_auction' THEN 1
      WHEN 'preferred' THEN 2
      WHEN 'public_auction' THEN 3
      END"),
      priority: :asc,
      price: :desc)
  }

  scope :active, -> { where(is_active: true) }
  # additional config .........................................................
  # class methods .............................................................
  def self.deal_type_priority
    {
      "private_auction" => 1,
      "preferred" => 2,
      "public_auction" => 3
    }
  end

  # public instance methods ...................................................
  def priority_weight
    self.class.deal_type_priority[deal_type]
  end

  def remaining_budget
    return nil if total_budget.nil?
    total_budget - spent_budget
  end

  def budget_spent_percentage
    return 0 if total_budget.nil? || total_budget.zero?
    (spent_budget / total_budget * 100).round(2)
  end

  def set_commission_details!(rate:, type:, settings: {})
    raise "Unauthorized" unless Current.user.admin?

    update!(
      commission_rate: rate,
      commission_type: type,
      commission_settings: settings
    )
  end

  def publisher_view
    {
      id: id,
      name: name,
      total_budget: commission_type.hidden? ? nil : total_budget,
      your_revenue: publisher_revenue,     # 只看到自己的收益
      status: status,
      start_date: start_date,
      end_date: end_date
    }
  end

  def publisher_revenue
    impressions.sum(:publisher_revenue)
  end

  def admin_view
    {
      id: id,
      name: name,
      total_budget: total_budget,
      commission_rate: commission_rate,
      commission_type: commission_type,
      commission_settings: commission_settings,
      publisher_revenue: publisher_revenue,
      platform_revenue: platform_revenue,
      status: status
    }
  end

  def platform_revenue
    impressions.sum(:platform_revenue)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def spent_budget_cannot_exceed_total_budget
    return if total_budget.nil? || spent_budget.nil?
    if spent_budget > total_budget
      errors.add(:spent_budget, "cannot exceed total budget")
    end
  end

  def set_default_commission_rate
    return if commission_rate.present?
    self.commission_rate = ad_space&.publisher&.default_commission_rate
  end

  def ensure_commission_settings_format
    self.commission_settings = {} if commission_settings.nil?
  end
end
