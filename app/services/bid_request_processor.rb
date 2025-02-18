# frozen_string_literal: true

class BidRequestProcessor
  include ApplicationHelper

  def initialize(ad_request)
    @ad_request = ad_request
    @ad_unit = ad_request.ad_unit
    @dsp_connector = DspConnector.new
  end

  def process
    # 1. Build OpenRTB bid request
    rtb_request = build_rtb_request

    # 2. Send requests to DSPs
    responses = request_all_dsps(rtb_request)

    # 3. Process responses
    winning_bid = select_winning_bid(responses)

    # 4. Update ad request
    update_ad_request(responses, winning_bid)

    # 5. Handle response based on type
    winning_bid["adm"].present? ? handle_vast_response(winning_bid) : format_regular_response(winning_bid)
  end

private

  def update_ad_request(responses, winning_bid)
    @ad_request.bid_response = responses
    @ad_request.win_bid_id = winning_bid&.dig("id")
    @ad_request.win_bid_price = winning_bid&.dig("price")
    @ad_request.win_bid_imp_id = winning_bid&.dig("impid")
    @ad_request.nurl = winning_bid.dig("nurl")
    @ad_request.burl = winning_bid.dig("burl")
    @ad_request.save
  end

  def build_rtb_request
    OpenRtbBuilder.new(@ad_request).build
  end

  def request_all_dsps(rtb_request)
    DSP_CONFIGS.select { |dsp_config| dsp_config[:is_active] }.map do |dsp_config|
      @dsp_connector.request(dsp_config, rtb_request)
    end.compact
  end

  def select_winning_bid(responses)
    return nil if responses.empty?

    bids = responses.flat_map { |response| response.dig("seatbid") || [] }
                    .flat_map { |seatbid| seatbid.dig("bid") || [] }
    winning_bid = bids.max_by { |bid| bid.dig("price") }

    if winning_bid.dig("price") < @ad_unit.ad_space.floor_price
      raise ArgumentError, "No valid bids above floor price"
    end

    Impression.create!(
      ad_unit: @ad_unit,
      deal_id: winning_bid.dig("deal"),
      revenue: winning_bid.dig("price"),
    # ip_address: @ad_request.ip_address,
    # user_agent: @ad_request.user_agent,
    # geo_location: @ad_request.geo_location
    )

    winning_bid
  end

  def handle_vast_response(bid)
    vast_validator = VastValidator.new(bid["adm"])
    raise ArgumentError, "Invalid VAST response" unless vast_validator.valid?

    {
      vast_url: bid["adm"],
      creative_loaded_url: creative_loaded_url,
      burl: burl
    }
  end

  def format_regular_response(bid)
    {
      creative_url: bid["banner"]["img"],
      creative_loaded_url: creative_loaded_url,
      burl: burl
    }
  end
end
