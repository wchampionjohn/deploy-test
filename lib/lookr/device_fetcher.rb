# frozen_string_literal: true

# fetch devices from Lookr API
# if id is present, fetch a single device
# if id is not present, fetch all devices
module Lookr
  class DeviceFetcher
    Result = Struct.new(:success?, :is_last_page?, :devices, :device, keyword_init: true)

    def initialize(device_lookr_id: nil, page: 1)
      @device_lookr_id, @page = device_lookr_id, page
      access_token = User.last.kabob_access_token

      url = if @device_lookr_id.present?
              URI("#{ENV["LOOKR_API_URL"]}/devices/#{@device_lookr_id}")
            else
              URI("#{ENV["LOOKR_API_URL"]}/devices?page=#{@page}")
            end

      @http = Net::HTTP.new(url.host, url.port)
      @http.use_ssl = true

      @request = Net::HTTP::Get.new(url)
      @request["Authorization"] = "Bearer #{access_token}"
      @request["Content-Type"] = "application/json; charset=utf-8"
    end

    def execute
      if @device_lookr_id.present?
        find_detail
      else
        fetch_devices
      end
    end

  private
    # Sample response from Lookr API
    # {
    #   "device": {
    #     "id": 499,
    #     "name": "Wei Heng testing - MK",
    #     "layouts": [
    #       {
    #         "width": 1080,
    #         "height": 1920,
    #         "viewport_width": 1080,
    #         "viewport_height": 1920,
    #         "offset_x": 0,
    #         "offset_y": 0,
    #         "blocks": [
    #           {
    #             "x": 115,
    #             "y": 0,
    #             "width": 965,
    #             "height": 1920,
    #             "index": 0,
    #             "id": 1
    #           }
    #         ]
    #       }
    #     ]
    #   }
    # }
    def find_detail
      is_success = false
      device = {}

      response = @http.request(@request)

      if response.is_a?(Net::HTTPSuccess)
        is_success = true

        data = JSON.parse(response.body)
        device = data["device"]
      end

      Result.new(
        success?: is_success,
        device: device
      )
    end

    def fetch_devices
      is_last_page = true
      is_success = false
      devices = []

      response = @http.request(@request)

      if response.is_a?(Net::HTTPSuccess)
        is_success = true

        data = JSON.parse(response.body)
        devices = data["devices"]
        is_last_page = data["meta"]["total_pages"] == @page
      end
      puts "is_last_page in fetcher: #{is_last_page}"

      Result.new(
        success?: is_success,
        is_last_page?: is_last_page,
        devices: devices
      )
    end
  end
end
