class CreateAdRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_requests do |t|
      t.bigint :ad_unit_id, comment: '關聯的廣告單元ID'
      t.bigint :device_id, comment: '關聯的裝置ID'
      t.string :uid, comment: '廣告請求唯一識別碼'
      t.string :ip_address, comment: '請求IP地址'
      t.jsonb :geo_location, comment: '地理位置信息'
      t.jsonb :user_agent, comment: '用戶代理信息'
      t.jsonb :bid_request, comment: 'OpenRTB請求內容'
      t.string :status, comment: '請求狀態: pending, processed, error'
      t.datetime :processed_at, comment: '處理時間'
      t.string :error_message, comment: '錯誤信息'
      t.timestamps
    end

    add_index :ad_requests, :ad_unit_id
    add_index :ad_requests, :device_id
    add_index :ad_requests, :uid, unique: true
  end
end
