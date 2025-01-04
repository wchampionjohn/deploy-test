class CreatePublishers < ActiveRecord::Migration[8.0]
  def change
    create_table :publishers do |t|
      t.string :name, comment: '發布商名稱'
      t.string :domain, comment: '發布商網域'
      t.string :category, comment: '發布商類型, 如：新聞、娛樂等'
      t.boolean :is_active, default: false, comment: '是否啟用'
      t.jsonb :settings, default: {}, comment: '發布商設定，廣告限制、內容分類等'

      t.string :contact_email, comment: '聯絡人信箱'
      t.string :contact_phone, comment: '聯絡人電話'
      t.text :description, comment: '發布商描述'
      t.timestamps
    end

    add_index :publishers, :domain, unique: true
  end
end
