# frozen_string_literal: true

class BidRequestProcessor
  def initialize(ad_request)
    @ad_request = ad_request
    @ad_unit = ad_request.ad_unit
    @dsp_connector = DspConnector.new
  end

  def process
    # 1. Build OpenRTB bid request
    rtb_request = build_rtb_request

    # 2. Add VAST config if supported
    add_vast_config(rtb_request) if @ad_unit.vast_enabled

    # 3. Send requests to DSPs
    responses = request_all_dsps(rtb_request)

    # 4. Process responses
    winning_bid = select_winning_bid(responses)

    # 5. Handle response based on type
    winning_bid["vast_url"].present? ? handle_vast_response(winning_bid) : format_regular_response(winning_bid)
  end

  private

  def build_rtb_request
    OpenRtbBuilder.new(@ad_request).build
  end

  def add_vast_config(rtb_request)
    size = @ad_unit.size.split("x")
    rtb_request[:imp].first[:video] = {
      mimes: @ad_unit.supported_formats,
      protocols: [ 2, 3, 5, 6 ], # VAST 2.0, 3.0, 4.0, 4.1
      w: size[0].to_i,
      h: size[1].to_i,
      linearity: 1,
      playbackmethod: [ 2 ], # Auto-play with sound on
      delivery: [ 1 ], # Download and play
      pos: @ad_unit.placement["position"] == "fullscreen" ? 7 : 0
    }
  end

  def request_all_dsps(rtb_request)
    DSP_CONFIGS.map do |dsp_config|
      @dsp_connector.request(dsp_config, rtb_request)
    end.compact
  end

  def select_winning_bid(responses)
    return nil if responses.empty?

    Rails.logger.info("Responses: #{responses}")

    winning_bid = responses.max_by { |response| response.price }

    if winning_bid.price < @ad_unit.ad_space.floor_price
      raise ArgumentError, "No valid bids above floor price"
    end

    Impression.create!(
      ad_unit: @ad_unit,
      deal: winning_bid.deal,
      revenue: winning_bid.price,
      # ip_address: @ad_request.ip_address,
      # user_agent: @ad_request.user_agent,
      # geo_location: @ad_request.geo_location
    )

    winning_bid
  end

  def handle_vast_response(bid)
    vast_validator = VastValidator.new(bid.vast_url)
    raise ArgumentError, "Invalid VAST response" unless vast_validator.valid?

    {
      vast_url: bid.vast_url,
      price: bid.price,
      impression_id: bid.id
    }
  end

  def format_regular_response(bid)
    {
      ad_markup: bid.ad_markup,
      price: bid.price,
      impression_id: bid.id
    }
  end
end
