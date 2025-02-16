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
require 'rails_helper'

RSpec.describe ContentTaxonomy, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
