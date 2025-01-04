class CreateScreens < ActiveRecord::Migration[8.0]
  def change
    create_table :screens do |t|
      t.bigint :device_id, comment: '關聯的裝置ID'
      t.string :uid, comment: '螢幕唯一識別碼'
      t.string :physical_location, comment: '螢幕實體位置描述'
      t.string :orientation, comment: '螢幕方向: portrait, landscape'
      t.string :resolution, comment: '解析度, 如: 1920x1080'
      t.integer :brightness_level, comment: '亮度等級'
      t.string :operational_status, comment: '運作狀態: normal, maintenance, error'
      t.boolean :is_active, default: true, comment: '螢幕是否啟用'
      t.jsonb :settings, default: {}, comment: '螢幕設定'
      t.timestamps
    end

    # add_index :screens, :device_id
    # add_index :screens, :uid, unique: true
  end
end
