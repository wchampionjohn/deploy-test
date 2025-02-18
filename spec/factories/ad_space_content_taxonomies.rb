# == Schema Information
#
# Table name: ad_space_content_taxonomies
#
#  id                                                           :bigint           not null, primary key
#  cat_type(acat(Audience Category) or bcat(Blocking Category)) :string
#  created_at                                                   :datetime         not null
#  updated_at                                                   :datetime         not null
#  ad_space_id                                                  :integer
#  content_taxonomy_id                                          :integer
#
# Indexes
#
#  index_ad_space_content_taxonomies_on_ad_space_id          (ad_space_id)
#  index_ad_space_content_taxonomies_on_content_taxonomy_id  (content_taxonomy_id)
#
FactoryBot.define do
  factory :ad_space_content_taxonomy do
    
  end
end
