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
FactoryBot.define do
  factory :ad_unit_time_multiplier do
    
  end
end
