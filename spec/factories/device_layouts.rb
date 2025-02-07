# == Schema Information
#
# Table name: device_layouts
#
#  id                      :bigint           not null, primary key
#  height                  :integer
#  width                   :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  device_id(關聯的裝置ID) :bigint
#
FactoryBot.define do
  factory :device_layout do
    
  end
end
