class CreateAdSpaces < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_spaces do |t|
      t.bigint :publisher_id, comment: '發布商ID'
      t.string :name, comment: '廣告版位名稱'
      t.string :ad_format, null: false, comment: '廣告格式, banner, video, native'
      t.integer :width, comment: '寬度'
      t.integer :height, comment: '高度'
      t.boolean :is_active, default: false, comment: '是否啟用'
      t.decimal :floor_price, precision: 10, scale: 4, comment: '底價'
      t.jsonb :targeting, default: {}, comment: '目標設定，如：地理、時段等'
      t.string :status, comment: '狀態, pending, active, inactive'
      t.text :description, comment: '描述'

      t.timestamps
    end

    add_index :ad_spaces, [ :publisher_id, :name ], unique: true
  end
end
