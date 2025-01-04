class CreateDeals < ActiveRecord::Migration[8.0]
  def change
    create_table :deals do |t|
      t.bigint :ad_space_id, comment: '廣告版位ID'

      t.string :uid, comment: 'Deal唯一識別碼'
      t.string :name, comment: 'Deal名稱'
      t.string :deal_type, comment: 'Deal類型: preferred, private_auction'
      t.decimal :price, precision: 10, scale: 4, comment: '價格(CPM)'
      t.datetime :start_date, comment: '開始日期'
      t.datetime :end_date, comment: '結束日期'
      t.boolean :is_active, default: true, comment: 'Deal是否啟用'
      t.jsonb :settings, default: {}, comment: 'Deal設定'
      t.integer :priority, comment: '優先順序'
      t.string :currency, default: 'USD', comment: '價格幣別'

      t.timestamps
    end

    add_index :deals, :uid, unique: true
    add_index :deals, :ad_space_id
  end
end
