class CreateSudos < ActiveRecord::Migration[8.0]
  def change
    create_table :sudos do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :sudos, :email_address, unique: true
  end
end
