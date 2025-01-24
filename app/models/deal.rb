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
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_space

  has_many :deal_buyers
  has_many :impressions
  # validations ...............................................................
  validates :deal_type, presence: true
  validates :uid, presence: true, uniqueness: true

  # callbacks .................................................................
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
  # protected instance methods ................................................
  # private instance methods ..................................................
end
