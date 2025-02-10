class CreateSystemLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :system_logs do |t|
      t.string :level
      t.string :title
      t.text :body
      t.boolean :notify, default: true

      t.timestamps
    end
  end
end
