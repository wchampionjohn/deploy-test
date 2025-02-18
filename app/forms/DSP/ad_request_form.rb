# frozen_string_literal: true

module DSP
  class AdRequestForm < BaseForm
    # permit_params .............................................................
    PERMIT_PARAMS = [
      :ip,
      :user_agent,
      :timestamp,
      :dt,
      :resolution,
      :geo
    ]

    attr_reader *PERMIT_PARAMS
    attr_reader :ad_request

    attribute :ip
    attribute :user_agent

    attribute :resolution
    attribute :go

    validates :ip, ip_address: true
    validates :user_agent, presence: true, length: { maximum: 255 }
    validates :resolution, presence: true

    validate :validate_resolution
    validate :validate_geo

    def initialize(device, params: {})
      params[:dt] = Time.at(params[:dt]) if params[:dt].is_a? Integer
      init_form(nil, params)
      @device = device
      @ad_request = AdRequest.new
    end

    def save
      return false unless valid?
      return false unless find_screen
      return false unless find_active_ad_units
      return false unless find_optimal_ad_unit

      @ad_request.notification_status = "pending"
      @ad_request.device = @device
      @ad_request.ad_unit = @matched_ad_unit
      @ad_request.applied_multiplier = @matched_ad_unit.get_multiplier_for_time(@dt)
      @ad_request.ip_address = attributes[:ip]
      @ad_request.user_agent = attributes[:user_agent]
      @ad_request.processed_at = attributes[:timestamp]
      @ad_request.geo_location = attributes[:geo]
      @ad_request.estimated_display_time = attributes[:dt]

      @ad_request.bid_request = OpenRtbBuilder.new(@ad_request).build

      begin
        @ad_request.save!
      rescue ActiveRecord::RecordInvalid
        self.errors.merge! @ad_request.errors
        return false
      end

      true
    end

  private

    def find_screen
      @screen = @device.screens.find_by(width: @resolution[:width], height: @resolution[:height])

      if @screen.nil?
        errors.add(:resolution, "找不到對應的螢幕解析度")
        return false
      end

      true
    end

    def find_active_ad_units
      ad_units = @screen.ad_units
      if ad_units.empty?
        errors.add(:base, "screen 沒有任何對應的 ad_unit")
        return false
      end

      @ad_units = ad_units.active

      if @ad_units.empty?
        errors.add(:base, "ad units 未啟用")
        return false
      end

      true
    end

    def find_optimal_ad_unit
      @matched_ad_unit = OptimalAdUnitQuery.new(@ad_units, @dt).call

      if @matched_ad_unit.nil?
        errors.add(:base, "ad units 中沒有符合條件的 ad unit")
        return false
      end

      true
    end

    def validate_resolution
      unless resolution.present? && resolution[:width].is_a?(Integer) && resolution[:height].is_a?(Integer)
        errors.add(:resolution, "必須包含正確的 width 與 height 屬性")
      end
    end

    def validate_geo
      return true if geo.blank?

      unless geo.present? && geo[:lat].is_a?(Float) && geo[:lon].is_a?(Float)
        errors.add(:geo, "必須包含正確的 lat 與 lon 屬性")
      end
    end

  end
end
