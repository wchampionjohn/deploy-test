# frozen_string_literal: true

# == Schema Information
#
# Table name: publishers
#
#  id                                         :bigint           not null, primary key
#  category(發布商類型, 如：新聞、娛樂等)     :string
#  contact_email(聯絡人信箱)                  :string
#  contact_phone(聯絡人電話)                  :string
#  description(發布商描述)                    :text
#  domain(發布商網域)                         :string
#  is_active(是否啟用)                        :boolean          default(FALSE)
#  name(發布商名稱)                           :string
#  settings(發布商設定，廣告限制、內容分類等) :jsonb
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#
# Indexes
#
#  index_publishers_on_domain  (domain) UNIQUE
#
class Publisher < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  has_many :publishers_users
  has_many :users, through: :publishers_users

  has_many :ad_spaces
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
