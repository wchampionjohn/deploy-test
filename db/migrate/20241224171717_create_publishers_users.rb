class CreatePublishersUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :publishers_users do |t|
      t.integer :publisher_id
      t.integer :user_id
      t.string :role, null: false
      t.boolean :is_active, default: false
      t.jsonb :permissions, default: {}
      t.timestamps
    end

    add_index :publishers_users, [ :publisher_id, :user_id ], unique: true
  end
end
