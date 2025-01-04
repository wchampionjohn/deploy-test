class CreateVastResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :vast_responses do |t|
      t.bigint :ad_request_id, comment: '關聯的廣告請求ID'
      t.bigint :impression_id, comment: '關聯的展示ID'
      t.string :uid, comment: 'VAST回應唯一識別碼'
      t.text :vast_xml, comment: 'VAST XML內容'
      t.string :vast_version, comment: 'VAST版本'
      t.jsonb :metadata, comment: '其他元資料'
      t.timestamps
    end

    add_index :vast_responses, :ad_request_id
    add_index :vast_responses, :impression_id
    add_index :vast_responses, :uid, unique: true
    add_index :vast_responses, :vast_version
  end
end
