class AdUnit < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_space
  belongs_to :screen

  has_many :ad_requests
  has_many :impressions
  has_many :vast_responses, dependent: :destroy
  # validations ...............................................................
  validates :unit_type, presence: true, if: -> { ad_space.present? && screen.present? }
  # callbacks .................................................................
  # scopes ....................................................................
  scope :active, -> { where(is_active: true) }
  scope :vast_enabled, -> { where(vast_enabled: true) }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def recent_vast_responses(limit = 10)
    vast_responses.recent.limit(limit)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
