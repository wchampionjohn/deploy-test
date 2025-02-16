# == Schema Information
#
# Table name: content_taxonomies(from IAB Content Taxonomies)
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  iab_unique_id :string
#
# Indexes
#
#  index_content_taxonomies_on_iab_unique_id  (iab_unique_id) UNIQUE
#
FactoryBot.define do
  factory :content_taxonomy do
    
  end
end
