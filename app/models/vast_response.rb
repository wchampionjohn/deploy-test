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
