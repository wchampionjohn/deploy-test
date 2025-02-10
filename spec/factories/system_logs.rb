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
FactoryBot.define do
  factory :system_log do
    
  end
end
