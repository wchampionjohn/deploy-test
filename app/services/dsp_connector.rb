# frozen_string_literal: true

require "net/http"

class DspConnector
  def request(dsp_config, rtb_request)
    case dsp_config[:name]
    when "appier"
      request_appier(rtb_request)
    when "ttd"
      request_ttd(rtb_request)
    when "kabob"
      request_kabob(dsp_config, rtb_request)
    end
  end

  private

  def request_appier(rtb_request)
    response = HTTP.timeout(0.5)
                  .headers(appier_headers)
                  .post(APPIER_ENDPOINT, json: rtb_request)

    handle_response(response)
  rescue HTTP::TimeoutError
    nil
  end

  def request_ttd(rtb_request)
    response = HTTP.timeout(0.5)
                  .headers(ttd_headers)
                  .post(TTD_ENDPOINT, json: rtb_request)

    handle_response(response)
  rescue HTTP::TimeoutError
    nil
  end

  def request_kabob(dsp_config, rtb_request)
    is_video = rtb_request[:imp].any? { |imp| imp.include? :video }

    url = URI(dsp_config[:endpoint])
    http = Net::HTTP.new(url.host, url.port)
    http.open_timeout = 2
    http.read_timeout = 5

    request = Net::HTTP::Post.new(url)
    form_data = {
      is_video: is_video ? true : nil
    }.compact

    request.set_form_data(form_data, 'application/x-www-form-urlencoded')

    begin
      response = http.request(request)
      JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    rescue Net::OpenTimeout, Net::ReadTimeout
      Rails.logger.error("DSP Request Timeout: #{url}")
      nil
    rescue StandardError => e
      Rails.logger.error("DSP Request Failed: #{e.message}")
      nil
    end

  end
end
