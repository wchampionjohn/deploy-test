# frozen_string_literal: true

# == Schema Information
#
# Table name: system_logs
#
#  id         :bigint           not null, primary key
#  body       :text
#  level      :string
#  notify     :boolean          default(TRUE)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
=begin
  Using Example:

    SystemLog.error.create!(
      title: "執行失敗！",
      body: "some error message ...",
      notify: false,
    )

    SystemLog.error.create!(
      title: "執行失敗！",
      error: e, # error 物件
      body_payload: {
        order_id: order.id,   # 額外資訊
        user_name: user.name, # 額外資訊
      },
    )

=end

class SystemLog < ApplicationRecord
  include ActionView::Helpers::SanitizeHelper

  attr_accessor :error # 將 error 物件轉換成錯誤訊息並合併至 `body_payload`
  attr_accessor :body_payload # 傳入額外的 hash 資料，並轉換成文字儲存至 body 欄位
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  # validations ...............................................................
  validates :level, presence: :true
  # callbacks .................................................................
  after_initialize do
    self.body_payload ||= {}
    self.body_payload.merge!({
                               error_class: error&.class,
                               error_message: error&.message&.first(300),
                               error_backtrace: error&.backtrace&.first(10),
                             }) if error.present?

    self.body = concat_string(body_payload) if body.blank? && body_payload.present?
  end
  before_save :sanitize_content
  after_create :send_notification!, if: -> { notify && error? }
  # scopes ....................................................................
  # additional config .........................................................
  attribute :level, :string, default: "error"
  enum :level, {
    debug: "debug",
    info: "info",
    warn: "warn",
    error: "error", # will send notification!
  }
  # class methods .............................................................
  # public instance methods ...................................................
  def send_notification!
    # TODO send notification
    puts "send notification"
  end

  def update_recently
    super(:updated_at, 1.day)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def concat_string(msg, concat_symbol = "：")
    if msg.class == Hash
      msg.keys.reduce("") do |acc, cur_key|
        value = msg[cur_key]

        acc += "#{cur_key}#{concat_symbol}#{value}<br/>"
        acc
      end
    else
      msg.inspect
    end
  end

  def sanitize_content
    self.body = sanitize(self.body, tags: %w(br strong em))
  end
end
