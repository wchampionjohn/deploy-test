# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_30_172824) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ad_requests", force: :cascade do |t|
    t.bigint "ad_unit_id", comment: "關聯的廣告單元ID"
    t.bigint "device_id", comment: "關聯的裝置ID"
    t.string "uid", comment: "廣告請求唯一識別碼"
    t.string "ip_address", comment: "請求IP地址"
    t.jsonb "geo_location", comment: "地理位置信息"
    t.jsonb "user_agent", comment: "用戶代理信息"
    t.jsonb "bid_request", comment: "OpenRTB請求內容"
    t.string "status", comment: "請求狀態: pending, processed, error"
    t.datetime "processed_at", comment: "處理時間"
    t.string "error_message", comment: "錯誤信息"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_unit_id"], name: "index_ad_requests_on_ad_unit_id"
    t.index ["device_id"], name: "index_ad_requests_on_device_id"
    t.index ["uid"], name: "index_ad_requests_on_uid", unique: true
  end

  create_table "ad_spaces", force: :cascade do |t|
    t.bigint "publisher_id", comment: "發布商ID"
    t.string "name", comment: "廣告版位名稱"
    t.string "ad_format", null: false, comment: "廣告格式, banner, video, native"
    t.integer "width", comment: "寬度"
    t.integer "height", comment: "高度"
    t.boolean "is_active", default: false, comment: "是否啟用"
    t.decimal "floor_price", precision: 10, scale: 4, comment: "底價"
    t.jsonb "targeting", default: {}, comment: "目標設定，如：地理、時段等"
    t.string "status", comment: "狀態, pending, active, inactive"
    t.text "description", comment: "描述"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id", "name"], name: "index_ad_spaces_on_publisher_id_and_name", unique: true
  end

  create_table "ad_units", force: :cascade do |t|
    t.bigint "ad_space_id", comment: "廣告版位ID"
    t.bigint "screen_id", comment: "螢幕ID"
    t.string "unit_type", null: false, comment: "單元類型, 如: display, video"
    t.string "size", comment: "廣告尺寸, 如: 300x250"
    t.jsonb "placement", default: {}, comment: "版位放置設定"
    t.boolean "is_active", default: true, comment: "廣告單元是否啟用"
    t.decimal "floor_price", precision: 10, scale: 4, comment: "單元特定底價，可覆蓋版位底價"
    t.boolean "vast_enabled", default: false, comment: "是否支援VAST"
    t.string "supported_formats", default: [], comment: "支援的廣告格式陣列", array: true
    t.jsonb "settings", default: {}, comment: "其他設定"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deal_buyers", force: :cascade do |t|
    t.bigint "deal_id", comment: "關聯的Deal ID"
    t.string "uid", comment: "買家唯一識別碼"
    t.string "name", comment: "買家名稱"
    t.boolean "is_active", default: true, comment: "買家是否啟用"
    t.jsonb "settings", default: {}, comment: "買家設定"
    t.string "contact_email", comment: "聯絡人郵箱"
    t.decimal "seat_bid_floor", precision: 10, scale: 4, comment: "買家特定底價"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_deal_buyers_on_deal_id"
    t.index ["uid"], name: "index_deal_buyers_on_uid", unique: true
  end

  create_table "deals", force: :cascade do |t|
    t.bigint "ad_space_id", comment: "廣告版位ID"
    t.string "uid", comment: "Deal唯一識別碼"
    t.string "name", comment: "Deal名稱"
    t.string "deal_type", comment: "Deal類型: preferred, private_auction"
    t.decimal "price", precision: 10, scale: 4, comment: "價格(CPM)"
    t.datetime "start_date", comment: "開始日期"
    t.datetime "end_date", comment: "結束日期"
    t.boolean "is_active", default: true, comment: "Deal是否啟用"
    t.jsonb "settings", default: {}, comment: "Deal設定"
    t.integer "priority", comment: "優先順序"
    t.string "currency", default: "USD", comment: "價格幣別"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_space_id"], name: "index_deals_on_ad_space_id"
    t.index ["uid"], name: "index_deals_on_uid", unique: true
  end

  create_table "devices", force: :cascade do |t|
    t.string "uid", comment: "裝置唯一識別碼"
    t.string "name", comment: "裝置名稱"
    t.string "platform", comment: "設備平台, 如: Android, Windows"
    t.jsonb "properties", default: {}, comment: "設備屬性"
    t.datetime "last_heartbeat", comment: "最後心跳時間"
    t.string "status", comment: "設備狀態: online, offline, maintenance"
    t.float "latitude", comment: "緯度"
    t.float "longitude", comment: "經度"
    t.boolean "is_active", default: true, comment: "設備是否啟用"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_devices_on_uid", unique: true
  end

  create_table "impressions", force: :cascade do |t|
    t.bigint "ad_unit_id", comment: "關聯的廣告單元ID"
    t.bigint "deal_id", comment: "關聯的Deal ID"
    t.string "uid", comment: "展示唯一識別碼"
    t.decimal "revenue", precision: 10, scale: 4, comment: "收益金額"
    t.jsonb "bid_response", comment: "OpenRTB回應內容"
    t.string "creative_url", comment: "素材URL"
    t.integer "duration", comment: "素材時長（影片用）"
    t.datetime "started_at", comment: "開始播放時間"
    t.datetime "completed_at", comment: "完成播放時間"
    t.string "status", comment: "狀態: pending, playing, completed, error"
    t.jsonb "tracking_events", comment: "VAST追蹤事件記錄"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_unit_id"], name: "index_impressions_on_ad_unit_id"
    t.index ["deal_id"], name: "index_impressions_on_deal_id"
    t.index ["uid"], name: "index_impressions_on_uid", unique: true
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", comment: "發布商名稱"
    t.string "domain", comment: "發布商網域"
    t.string "category", comment: "發布商類型, 如：新聞、娛樂等"
    t.boolean "is_active", default: false, comment: "是否啟用"
    t.jsonb "settings", default: {}, comment: "發布商設定，廣告限制、內容分類等"
    t.string "contact_email", comment: "聯絡人信箱"
    t.string "contact_phone", comment: "聯絡人電話"
    t.text "description", comment: "發布商描述"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_publishers_on_domain", unique: true
  end

  create_table "publishers_users", force: :cascade do |t|
    t.integer "publisher_id"
    t.integer "user_id"
    t.string "role", null: false
    t.boolean "is_active", default: false
    t.jsonb "permissions", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id", "user_id"], name: "index_publishers_users_on_publisher_id_and_user_id", unique: true
  end

  create_table "screens", force: :cascade do |t|
    t.bigint "device_id", comment: "關聯的裝置ID"
    t.string "uid", comment: "螢幕唯一識別碼"
    t.string "physical_location", comment: "螢幕實體位置描述"
    t.string "orientation", comment: "螢幕方向: portrait, landscape"
    t.string "resolution", comment: "解析度, 如: 1920x1080"
    t.integer "brightness_level", comment: "亮度等級"
    t.string "operational_status", comment: "運作狀態: normal, maintenance, error"
    t.boolean "is_active", default: true, comment: "螢幕是否啟用"
    t.jsonb "settings", default: {}, comment: "螢幕設定"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "sudo_id"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sudo_id"], name: "index_sessions_on_sudo_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sudos", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_sudos_on_email_address", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kabob_access_token", comment: "Kabob平台存取令牌"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "vast_responses", force: :cascade do |t|
    t.bigint "ad_request_id", comment: "關聯的廣告請求ID"
    t.bigint "impression_id", comment: "關聯的展示ID"
    t.string "uid", comment: "VAST回應唯一識別碼"
    t.text "vast_xml", comment: "VAST XML內容"
    t.string "vast_version", comment: "VAST版本"
    t.jsonb "metadata", comment: "其他元資料"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ad_request_id"], name: "index_vast_responses_on_ad_request_id"
    t.index ["impression_id"], name: "index_vast_responses_on_impression_id"
    t.index ["uid"], name: "index_vast_responses_on_uid", unique: true
    t.index ["vast_version"], name: "index_vast_responses_on_vast_version"
  end

  add_foreign_key "sessions", "sudos"
  add_foreign_key "sessions", "users"
end
