class CreateAdSpaceContentTaxonomies < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_space_content_taxonomies do |t|
      t.integer :ad_space_id
      t.integer :content_taxonomy_id
      t.string :cat_type,comment: 'acat(Audience Category) or bcat(Blocking Category)'
      t.timestamps

      t.index :ad_space_id
      t.index :content_taxonomy_id
    end
  end
end
