class CreateImpressions < ActiveRecord::Migration[8.0]
  def change
    create_table :impressions do |t|
      t.bigint :ad_unit_id, comment: '關聯的廣告單元ID'
      t.bigint :deal_id, comment: '關聯的Deal ID'
      t.string :uid, comment: '展示唯一識別碼'
      t.decimal :revenue, precision: 10, scale: 4, comment: '收益金額'
      t.jsonb :bid_response, comment: 'OpenRTB回應內容'
      t.string :creative_url, comment: '素材URL'
      t.integer :duration, comment: '素材時長（影片用）'
      t.datetime :started_at, comment: '開始播放時間'
      t.datetime :completed_at, comment: '完成播放時間'
      t.string :status, comment: '狀態: pending, playing, completed, error'
      t.jsonb :tracking_events, comment: 'VAST追蹤事件記錄'
      t.timestamps
    end

    add_index :impressions, :ad_unit_id
    add_index :impressions, :deal_id
    add_index :impressions, :uid, unique: true
  end
end
