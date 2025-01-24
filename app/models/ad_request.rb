# frozen_string_literal: true

# == Schema Information
#
# Table name: ad_requests
#
#  id                                          :bigint           not null, primary key
#  bid_request(OpenRTB請求內容)                :jsonb
#  error_message(錯誤信息)                     :string
#  geo_location(地理位置信息)                  :jsonb
#  ip_address(請求IP地址)                      :string
#  processed_at(處理時間)                      :datetime
#  status(請求狀態: pending, processed, error) :string
#  uid(廣告請求唯一識別碼)                     :string
#  user_agent(用戶代理信息)                    :jsonb
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  ad_unit_id(關聯的廣告單元ID)                :bigint
#  device_id(關聯的裝置ID)                     :bigint
#
# Indexes
#
#  index_ad_requests_on_ad_unit_id  (ad_unit_id)
#  index_ad_requests_on_device_id   (device_id)
#  index_ad_requests_on_uid         (uid) UNIQUE
#
class AdRequest < ApplicationRecord
  # extends ...................................................................
  enum :notification_status, {
    pending: "pending",
    creative_loaded: "creative_loaded",   # 新增狀態：素材已下載
    nurl_sent: "nurl_sent",               # DSP 已收到廣告下載成功通知
    burl_received: "burl_received",       # 收到 Device 播放完成通知
    burl_sent: "burl_sent",               # DSP 已收到播放完成通知
    completed: "completed",
    failed: "failed"
  }, default: :pending

  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_unit
  belongs_to :device

  # validations ...............................................................
  validates :qty_multiplier, numericality: { greater_than: 0 }, allow_nil: true

  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def notify_dsp_win
    return if nurl.blank?

    NotifyDspJob.perform_later(id, :nurl)
    update(notification_status: :nurl_sent)
  end

  def notify_dsp_billing
    return if burl.blank?

    NotifyDspJob.perform_later(id, :burl)
    update(notification_status: :burl_sent)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
