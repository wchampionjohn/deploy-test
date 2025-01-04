class CreateAdUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_units do |t|
      t.bigint :ad_space_id, comment: '廣告版位ID'
      t.bigint :screen_id, comment: '螢幕ID'
      t.string :unit_type, null: false, comment: '單元類型, 如: display, video'
      t.string :size, comment: '廣告尺寸, 如: 300x250'
      t.jsonb :placement, default: {}, comment: '版位放置設定'
      t.boolean :is_active, default: true, comment: '廣告單元是否啟用'
      t.decimal :floor_price, precision: 10, scale: 4, comment: '單元特定底價，可覆蓋版位底價'
      t.boolean :vast_enabled, default: false, comment: '是否支援VAST'
      t.string :supported_formats, array: true, default: [], comment: '支援的廣告格式陣列'
      t.jsonb :settings, default: {}, comment: '其他設定'
      t.timestamps
    end
  end
end
