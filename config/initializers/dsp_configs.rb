# config/initializers/dsp_configs.rb
DSP_CONFIGS = [
  {
    name: "appier",
    endpoint: ENV["APPIER_DSP_ENDPOINT"] || "https://api.appier.com/bid",
    credentials: {
      api_key: ENV["APPIER_API_KEY"]
    }
  },
  {
    name: "ttd",
    endpoint: ENV["TTD_DSP_ENDPOINT"] || "https://api.thetradedesk.com/bid",
    credentials: {
      api_key: ENV["TTD_API_KEY"]
    }
  }
  # Add more DSP configurations as needed
].freeze
