# frozen_string_literal: true

# app/services/vast_validator.rb
class VastValidator
  attr_reader :errors

  def initialize(xml)
    @xml = xml
    @errors = []
    validate
  end

  def valid?
    validate if @errors.empty?
    @errors.empty?
  end

  private

  def validate
    # Basic XML validation
    begin
      doc = Nokogiri::XML(@xml) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError => e
      @errors << "Invalid XML: #{e.message}"
      return
    end

    # VAST specific validation
    unless doc.at_xpath("//VAST")
      @errors << "Missing VAST root element"
      return
    end

    # Validate required elements
    required_elements = [ "Ad", "InLine", "Creative", "MediaFile" ]
    required_elements.each do |element|
      unless doc.at_xpath("//#{element}")
        @errors << "Missing required element: #{element}"
      end
    end
  end
end
# class VastValidator
#   def initialize(vast_xml)
#     @vast_xml = vast_xml
#     @errors = []
#   end

#   def valid?
#     validate_xml_structure
#     validate_ad_elements
#     @errors.empty?
#   end

#   def version
#     # Extract VAST version from XML
#     match = @vast_xml.match(/VAST version="(\d+\.\d+)"/)
#     match ? match[1] : nil
#   end

#   private

#   def validate
#     # Basic XML validation
#     begin
#       doc = Nokogiri::XML(@xml) { |config| config.strict }
#     rescue Nokogiri::XML::SyntaxError => e
#       @errors << "Invalid XML: #{e.message}"
#       return
#     end

#     # VAST specific validation
#     unless doc.at_xpath("//VAST")
#       @errors << "Missing VAST root element"
#       return
#     end

#     # Validate required elements
#     required_elements = [ "Ad", "InLine", "Creative", "MediaFile" ]
#     required_elements.each do |element|
#       unless doc.at_xpath("//#{element}")
#         @errors << "Missing required element: #{element}"
#       end
#     end
#   end

#   def validate_xml_structure
#     begin
#       Nokogiri::XML(@vast_xml) do |config|
#         config.strict
#       end
#     rescue Nokogiri::XML::SyntaxError => e
#       @errors << "Invalid XML structure: #{e.message}"
#     end
#   end

#   def validate_ad_elements
#     doc = Nokogiri::XML(@vast_xml)

#     # Check for required VAST elements
#     ad_elements = doc.xpath("//Ad")
#     @errors << "No Ad elements found" if ad_elements.empty?

#     ad_elements.each do |ad|
#       validate_creative(ad)
#     end
#   end

#   def validate_creative(ad_element)
#     # Check for valid media files
#     media_files = ad_element.xpath(".//MediaFile")
#     @errors << "No valid MediaFiles found" if media_files.empty?

#     media_files.each do |media_file|
#       validate_media_file(media_file)
#     end
#   end

#   def validate_media_file(media_file)
#     # Validate media file attributes
#     unless media_file["width"] && media_file["height"]
#       @errors << "MediaFile missing width or height"
#     end

#     unless %w[video/mp4 video/webm].include?(media_file["type"])
#       @errors << "Unsupported media file type"
#     end
#   end
# end
