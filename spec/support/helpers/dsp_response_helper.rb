require 'ostruct'

module DspResponseHelper
  def build_dsp_response(options = {})
    OpenStruct.new({
      price: options[:price] || 10.0,
      ad_markup: options[:ad_markup] || "<div>Test Ad</div>",
      vast_url: options[:vast_url],
      deal: options[:deal],
      currency: options[:currency] || "USD",
      width: options[:width] || 300,
      height: options[:height] || 250,
      creative_id: options[:creative_id] || "test_creative_#{Time.current.to_i}",
      advertiser_id: options[:advertiser_id] || "test_advertiser_#{Time.current.to_i}"
    })
  end

  def mock_dsp_request(response_or_error)
    if response_or_error.is_a?(StandardError)
      allow_any_instance_of(DspConnector).to receive(:request).and_raise(response_or_error)
    else
      allow_any_instance_of(DspConnector).to receive(:request).and_return(response_or_error)
    end
  end

  def mock_multiple_dsp_responses(responses)
    allow_any_instance_of(DspConnector).to receive(:request) do |_, dsp_config, _|
      responses[dsp_config[:id]] || build_dsp_response(price: 0)
    end
  end
end

RSpec.configure do |config|
  config.include DspResponseHelper, type: :request
end
