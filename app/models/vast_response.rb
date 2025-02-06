# frozen_string_literal: true

# == Schema Information
#
# Table name: vast_responses
#
#  id                              :bigint           not null, primary key
#  metadata(其他元資料)            :jsonb
#  uid(VAST回應唯一識別碼)         :string
#  vast_version(VAST版本)          :string
#  vast_xml(VAST XML內容)          :text
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  ad_request_id(關聯的廣告請求ID) :bigint
#  impression_id(關聯的展示ID)     :bigint
#
# Indexes
#
#  index_vast_responses_on_ad_request_id  (ad_request_id)
#  index_vast_responses_on_impression_id  (impression_id)
#  index_vast_responses_on_uid            (uid) UNIQUE
#  index_vast_responses_on_vast_version   (vast_version)
#
class VastResponse < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :ad_unit
  belongs_to :impression

  # validations ...............................................................
  validates :vast_xml, presence: true
  validates :vast_version, presence: true, inclusion: { in: %w[1.0 2.0 3.0 4.0] }

  # callbacks .................................................................
  before_validation :sanitize_vast_xml

  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  def self.create_from_bid(bid:, ad_unit:, impression: nil)
    create!(
      ad_unit: ad_unit,
      impression: impression,
      vast_xml: bid.vast_xml,
      vast_version: extract_vast_version(bid.vast_xml),
      metadata: {
        dsp_name: bid.dsp_name,
        price: bid.price
      }
    )
  end

  def self.extract_vast_version(vast_xml)
    doc = Nokogiri::XML(vast_xml)
    doc.root["version"]
  rescue
    nil
  end

  # public instance methods ...................................................
  def sanitize_vast_xml
    return if vast_xml.blank?

    # Remove any potentially harmful XML content
    sanitized = vast_xml.gsub(/<\?xml-stylesheet.*?\?>/i, "")
    self.vast_xml = sanitized
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
