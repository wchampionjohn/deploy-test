class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices do |t|
      t.string :uid, comment: '裝置唯一識別碼'
      t.string :name, comment: '裝置名稱'
      t.string :platform, comment: '設備平台, 如: Android, Windows'
      t.jsonb :properties, default: {}, comment: '設備屬性'
      t.datetime :last_heartbeat, comment: '最後心跳時間'
      t.string :status, comment: '設備狀態: online, offline, maintenance'
      t.float :latitude, comment: '緯度'
      t.float :longitude, comment: '經度'
      t.boolean :is_active, default: true, comment: '設備是否啟用'
      t.timestamps
    end

    add_index :devices, :uid, unique: true
  end
end
