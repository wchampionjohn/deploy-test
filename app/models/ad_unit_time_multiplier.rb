# == Schema Information
#
# Table name: ad_unit_time_multipliers
#
#  id                   :bigint           not null, primary key
#  day_of_week(星期幾)  :integer
#  end_time(結束時間)   :time
#  multiplier           :decimal(10, 4)
#  start_time(開始時間) :time
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ad_unit_id           :bigint
#
# Indexes
#
#  index_ad_unit_time_multipliers_on_ad_unit_id  (ad_unit_id)
#
class AdUnitTimeMultiplier < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_unit

  validates :day_of_week, inclusion: { in: 0..6 }
  validates :multiplier, numericality: { greater_than: 0 }
  validate :end_time_after_start_time

  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
