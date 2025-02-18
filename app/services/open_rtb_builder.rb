# frozen_string_literal: true

# app/services/open_rtb_builder.rb
class OpenRtbBuilder
  def initialize(ad_request)
    @ad_request = ad_request
    @ad_unit = ad_request.ad_unit
    @ad_space = @ad_unit.ad_space
  end

  def build
    {
      id: SecureRandom.uuid,
      imp: imp,
      device: build_device_info,
      app: build_app_info,
      user: build_user_info,
      dooh: build_dooh_info,
      pmp: build_pmp_info,
      bcat: @ad_space.cat_list("bcat"), # block categories
      acat: @ad_space.cat_list("acat"), # allowed categories
      cattax: 2, #  IAB 內容分類標準 2.0（IAB Content Taxonomy 2.0）
      tmax: 500 # DSP 回應的時間限制，超時則 SSP 不再等待。
    }.compact
  end

private

  def get_floor_price
    @ad_unit.ad_space.floor_price
  end

  # 先依照長寬支援圖片與影片，串 DSP 後再依照實際情況調整
  def imp
    w, h = @ad_unit.size.split("x").map(&:to_i)

    result = [
      {
        id: SecureRandom.uuid,
        tagid: "tag-#{@ad_unit.id}", # 暫時先用 ad_unit 的 id
        instl: 1, # 是否為全螢幕展示（1 = 是，0 = 否）
        bidfloor: get_floor_price,
        bidfloorcur: "USD",
        secure: 1,
        banner: {
          w: w,
          h: h,
          pos: 1
        },
      }
    ]

    if @ad_unit.vast_enabled?
      result.first.merge!(video: vast_config)
    end

    result
  end

  def vast_config
    size = @ad_unit.size.split("x")

    {
      mimes: @ad_unit.supported_formats,
      protocols: [2, 3, 5, 6], # VAST 2.0, 3.0, 4.0, 4.1
      w: size[0].to_i,
      h: size[1].to_i,
      linearity: 1,
      playbackmethod: [2], # Auto-play with sound on
      delivery: [1], # Download and play
      pos: @ad_unit.placement["position"] == "fullscreen" ? 7 : 0
    }
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
        lat: @ad_request.geo_location&.dig("lat"),
        lon: @ad_request.geo_location&.dig("lon")
      }
    }
  end

  # {
  #   "id": "com.example.fakeapp",
  #   "name": "Fake App",
  #   "bundle": "com.example.fakeapp.bundle",
  #   "storeurl": "https://apps.example.com/fakeapp",
  #   "cat": ["IAB1", "IAB2"],
  #   "ver": "1.2.3",
  #   "publisher": {
  #     "id": "pub-123456",
  #     "name": "Example Publisher"
  #   }
  # }
  def build_app_info
    {
      id: @ad_unit.ad_space.publisher.id.to_s,
      name: @ad_unit.ad_space.publisher.name
    }
  end

  # {
  #   "id": "user-78910",
  #   "buyeruid": "buyer-12345",
  #   "gender": "M",
  #   "yob": 1990,
  #   "keywords": "sports,news,technology",
  #   "geo": {
  #     "lat": 25.034,
  #     "lon": 121.5645
  #   },
  #   "data": [
  #     {
  #       "id": "segment-123",
  #       "name": "Sports Enthusiasts",
  #       "segment": [
  #         {
  #           "id": "seg-001",
  #           "name": "Football"
  #         },
  #         {
  #           "id": "seg-002",
  #           "name": "Basketball"
  #         }
  #       ]
  #     }
  #   ]
  # }
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
    }.compact # 移除 nil 值
  end

  def build_dooh_info
    return unless @ad_unit.ad_space.venue_type.present?

    {
      id: @ad_unit.screen&.uid,
      name: @ad_unit.ad_space.name,
      venuetype: [@ad_unit.ad_space.venue_type].compact,
      venuetypetax: 1, # Using OpenOOH Venue Taxonomy
      publisher: {
        id: @ad_unit.ad_space.publisher.id,
        name: @ad_unit.ad_space.publisher.name,
        domain: @ad_unit.ad_space.publisher.domain
      }.compact
    }.compact
  end

  # {
  #   "pmp": {
  #     "private_auction": 1,
  #     "deals": [
  #       {
  #         "id": "deal-123",
  #         "bidfloor": 0.5,
  #         "bidfloorcur": "USD",
  #         "at": 1
  #       },
  #       {
  #         "id": "deal-456",
  #         "bidfloor": 1.0,
  #         "bidfloorcur": "USD",
  #         "at": 1
  #       }
  #     ]
  #   }
  def build_pmp_info
    return nil unless @ad_unit.deals.present?

    deals = @ad_unit.deals.map do |deal|
      {
        id: deal.uid,
        bidfloor: deal.bidfloor,
        bidfloorcur: deal.bidfloorcur,
        at: deal.auction_type
      }
    end

    {
      "pmp": {
        "private_auction": 1,
        "deals": deals
      }
    }
  end
end
