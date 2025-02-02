class AddQtyAndNotificationUrlToAdRequest < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_requests, :qty_multiplier, :decimal, precision: 10, scale: 4, comment: '廣告單元底價倍率'
    add_column :ad_requests, :qty_source_type, :string, comment: '廣告單元底價來源類型'
    add_column :ad_requests, :qty_vendor, :string, comment: '廣告單元底價來源廠商'
    add_column :ad_requests, :qty_ext, :jsonb, comment: '廣告單元底價來源額外資訊'

    add_column :ad_requests, :nurl, :string, comment: 'Notification URL'
    add_column :ad_requests, :burl, :string, comment: 'Bid URL'
    add_column :ad_requests, :notification_status, :string, comment: 'Notification 狀態'
    add_column :ad_requests, :notified_at, :datetime, comment: '通知時間'

    add_index :ad_requests, :notification_status
  end
end
