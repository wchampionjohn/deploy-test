# frozen_string_literal: true

# config/initializers/dsp_configs.rb
DSP_CONFIGS = [
  {
    is_active: false,
    name: "appier",
    endpoint: ENV["APPIER_DSP_ENDPOINT"] || "https://api.appier.com/bid",
    credentials: {
      api_key: ENV["APPIER_API_KEY"]
    }
  },
  {
    is_active: false,
    name: "ttd",
    endpoint: ENV["TTD_DSP_ENDPOINT"] || "https://api.thetradedesk.com/bid",
    credentials: {
      api_key: ENV["TTD_API_KEY"]
    }
  },
  {
    is_active: true,
    name: "kabob",
    endpoint: ENV["INTERNAL_KABOB_PLATFORM_URL"] || "http://localhost:21000/api/vi/responses",
    credentials: {
      api_key: ENV["INTERNAL_KABOB_API_KEY"]
    }
  }
  # Add more DSP configurations as needed
].freeze
