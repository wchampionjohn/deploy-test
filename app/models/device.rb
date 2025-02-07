# frozen_string_literal: true

# == Schema Information
#
# Table name: devices
#
#  id                                                      :bigint           not null, primary key
#  is_active(設備是否啟用)                                 :boolean          default(TRUE)
#  last_heartbeat(最後心跳時間)                            :datetime
#  latitude(緯度)                                          :float
#  longitude(經度)                                         :float
#  name(裝置名稱)                                          :string
#  platform(設備平台, 如: Android, Windows)                :string
#  properties(設備屬性)                                    :jsonb
#  status(設備狀態: online, offline, maintenance)          :string
#  uid(裝置唯一識別碼)                                     :string
#  created_at                                              :datetime         not null
#  updated_at                                              :datetime         not null
#  lookr_id(來自 Lookr 的裝置 ID，用來fetch裝置的詳細資料) :integer
#
# Indexes
#
#  index_devices_on_uid  (uid) UNIQUE
#
class Device < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  has_many :screens
  # validations ...............................................................
  validates :uid, presence: true, uniqueness: true
  validates :name, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :active, -> { where(is_active: true) }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
