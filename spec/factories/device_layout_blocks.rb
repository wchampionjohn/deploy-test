# == Schema Information
#
# Table name: device_layout_blocks
#
#  id                      :bigint           not null, primary key
#  height                  :integer
#  index                   :integer
#  width                   :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  device_id(關聯的裝置ID) :bigint
#  device_layout_id        :bigint
#  lookr_id                :integer
#
FactoryBot.define do
  factory :device_layout_block do
    
  end
end
