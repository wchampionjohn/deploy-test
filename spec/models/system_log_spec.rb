# == Schema Information
#
# Table name: system_logs
#
#  id         :bigint           not null, primary key
#  body       :text
#  level      :string
#  notify     :boolean          default(TRUE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe SystemLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
