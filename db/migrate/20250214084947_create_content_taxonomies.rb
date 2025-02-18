class CreateContentTaxonomies < ActiveRecord::Migration[8.0]
  def change
    create_table :content_taxonomies, comment: 'from IAB Content Taxonomies' do |t|
      t.string :iab_unique_id
      t.string :name
      t.timestamps
      t.index :iab_unique_id, unique: true
    end
  end
end
