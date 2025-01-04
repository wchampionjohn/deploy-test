class DspConnector
  def request(dsp_config, rtb_request)
    case dsp_config.name
    when "appier"
      request_appier(rtb_request)
    when "ttd"
      request_ttd(rtb_request)
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
end
