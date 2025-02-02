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
