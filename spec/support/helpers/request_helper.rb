# frozen_string_literal: true

module RequestHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def auth_headers(token = nil)
    token ||= generate_test_token
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    }
  end

  def generate_test_token
    JWT.encode(
      {
        sub: "test_user",
        exp: 24.hours.from_now.to_i
      },
      Rails.application.credentials.jwt_secret_key
    )
  end

  def default_bid_request_params(options = {})
    {
      bid_request: {
        ad_unit_id: options[:ad_unit_id],
        device_id: options[:device_id],
        ip: options[:ip] || "192.168.1.1",
        resolution: options[:resolution] || { width: 640, height: 480 },
        user_agent: options[:user_agent] || "Mozilla/5.0",
        timestamp: options[:timestamp] || Time.current.iso8601,
        dt: options[:dt] || Time.current.to_i, # 預計播放時間
        geo: options[:geo] || {
          lat: 25.0330,
          lon: 121.5654,
          country: "TWN",
          city: "Taipei",
          zip: "100"
        }
      }
    }
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end
