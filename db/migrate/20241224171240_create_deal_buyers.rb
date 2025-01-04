class CreateDealBuyers < ActiveRecord::Migration[8.0]
  def change
    create_table :deal_buyers do |t|
      t.bigint :deal_id, comment: '關聯的Deal ID'
      t.string :uid, comment: '買家唯一識別碼'
      t.string :name, comment: '買家名稱'
      t.boolean :is_active, default: true, comment: '買家是否啟用'
      t.jsonb :settings, default: {}, comment: '買家設定'
      t.string :contact_email, comment: '聯絡人郵箱'
      t.decimal :seat_bid_floor, precision: 10, scale: 4, comment: '買家特定底價'
      t.timestamps
    end

    add_index :deal_buyers, :deal_id
    add_index :deal_buyers, :uid, unique: true
  end
end
