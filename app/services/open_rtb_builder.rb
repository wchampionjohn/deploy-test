# app/services/open_rtb_builder.rb
class OpenRtbBuilder
  def initialize(ad_request)
    @ad_request = ad_request
    @ad_unit = ad_request.ad_unit
  end

  def build
    {
      id: SecureRandom.uuid,
      imp: [ {
        id: SecureRandom.uuid,
        tagid: @ad_request.ad_unit_id,
        secure: 1,
        banner: {
          w: @ad_unit.size.split("x")[0],
          h: @ad_unit.size.split("x")[1]
        },
        bidfloor: get_floor_price,
        bidfloorcur: "USD",
        dt: @ad_request.estimated_display_time.to_i * 1000,  # 轉換為 Unix timestamp 毫秒
        qty: build_qty_info
      } ],
      device: build_device_info,
      app: build_app_info,
      user: build_user_info,
      dooh: build_dooh_info
    }.compact
  end

  private

  def get_floor_price
    @ad_unit.ad_space.floor_price
  end

  # bid_request: {
  #       ad_unit_id: options[:ad_unit_id],
  #       device_id: options[:device_id],
  #       ip: options[:ip] || "192.168.1.1",
  #       user_agent: options[:user_agent] || "Mozilla/5.0",
  #       timestamp: options[:timestamp] || Time.current.iso8601,
  #       geo: options[:geo] || {
  #         lat: 25.0330,
  #         lon: 121.5654
  #       }
  #     }

  def build_device_info
    {
      ua: @ad_request.user_agent,
      ip: @ad_request.ip_address,
      geo: {
        # country: @ad_request.location.country,
        # city: @ad_request.location.city,
        lat: @ad_request.geo_location["lat"],
        lon: @ad_request.geo_location["lon"]
      }
    }
  end

  def build_app_info
    {
      id: @ad_unit.ad_space.publisher.id,
      name: @ad_unit.ad_space.publisher.name
    }
  end

  def build_user_info
    {
      # id: @ad_request.device.user_id,
      # geo: build_device_info[:geo]
    }
  end

  def build_qty_info
    {
      multiplier: @ad_request.applied_multiplier,
      sourcetype: @ad_unit.qty_source_type_value,
      vendor: @ad_unit.qty_vendor,
      ext: @ad_unit.qty_ext
    }.compact  # 移除 nil 值
  end

  def build_dooh_info
    return unless @ad_unit.ad_space.venue_type.present?

    {
      id: @ad_unit.screen&.uid,
      name: @ad_unit.ad_space.name,
      venuetype: [ @ad_unit.ad_space.venue_type ].compact,
      venuetypetax: 1,  # Using OpenOOH Venue Taxonomy
      publisher: {
        id: @ad_unit.ad_space.publisher.id,
        name: @ad_unit.ad_space.publisher.name,
        domain: @ad_unit.ad_space.publisher.domain
      }.compact
    }.compact
  end
end
