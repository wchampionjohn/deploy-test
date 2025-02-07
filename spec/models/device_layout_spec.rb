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
require 'rails_helper'

RSpec.describe DeviceLayout, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
