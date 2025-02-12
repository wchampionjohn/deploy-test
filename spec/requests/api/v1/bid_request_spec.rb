# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::BidRequests", type: :request do
  let(:ad_space) { create(:ad_space, floor_price: 5.0) }
  let!(:screen) { create(:screen, device: device, width: 640, height: 480) }
  let!(:ad_unit) { create(:ad_unit, :with_24_7, ad_space: ad_space, screen: screen) }
  let(:device) { create(:device) }

  describe "POST /api/v1/bid_requests" do
    context "with valid parameters" do
      it "processes a regular bid request successfully" do
        mock_dsp_request(build_dsp_response(price: 10.0))

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               resolution: {
                 width: 640,
                 height: 480
               },
               device_id: device.id
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(json_response).to include(:ad_markup, :price, :impression_id)
      end

      it "processes a VAST bid request successfully" do
        ad_unit.update!(vast_enabled: true)
        mock_vast_response(valid: true)
        mock_dsp_request(
          build_dsp_response(
            price: 10.0,
            vast_url: "http://example.com/vast.xml",
            deal: create(:deal)
          )
        )

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               ad_unit_id: ad_unit.id,
               device_id: device.id
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(json_response).to include(:vast_url)
      end

      it "creates an impression record" do
        mock_dsp_request(build_dsp_response(price: 10.0))

        expect {
          post "/api/v1/bid_requests",
               params: default_bid_request_params(
                 ad_unit_id: ad_unit.id,
                 device_id: device.id
               ),
               as: :json,
               headers: auth_headers
        }.to change(Impression, :count).by(1)
      end

      it "processes a DOOH bid request successfully" do
        # 設定 ad_space 的 venue_type，而不是改變 unit_type
        ad_unit.ad_space.update!(venue_type: "airport")

        # 模擬 DSP 回應
        mock_dsp_request(build_dsp_response(price: 10.0))

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               ad_unit_id: ad_unit.id,
               device_id: device.id
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(AdRequest.last.bid_request).to include("dooh")
        expect(AdRequest.last.bid_request["dooh"]["venuetype"]).to eq(["airport"])
      end

      it "processes bid request with display time successfully" do
        display_time = Time.current.to_i
        mock_dsp_request(build_dsp_response(price: 10.0))

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               ad_unit_id: ad_unit.id,
               device_id: device.id,
               dt: display_time
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(AdRequest.last.estimated_display_time.to_i).to eq(display_time)
        expect(AdRequest.last.bid_request["imp"].first["dt"]).to eq(display_time * 1000) # 確認轉換為毫秒
      end
    end

    context "with invalid parameters" do
      it "returns error for missing resolution" do
        params = default_bid_request_params(device_id: device.id)
        params[:bid_request].delete(:resolution)

        post "/api/v1/bid_requests",
             params: params,
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error]).to be_present
      end

      it "returns error for invalid device_id" do
        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               device_id: 999999
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error]).to be_present
      end
    end

    context "error handling" do
      it "handles DSP timeout gracefully" do
        mock_dsp_request(Timeout::Error.new)

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               ad_unit_id: ad_unit.id,
               device_id: device.id
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error]).to include("timeout")
      end

      it "handles invalid VAST response" do
        ad_unit.update!(vast_enabled: true)
        mock_vast_response(valid: false)
        mock_dsp_request(
          build_dsp_response(
            price: 10.0,
            vast_url: "http://example.com/invalid_vast.xml"
          )
        )

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               ad_unit_id: ad_unit.id,
               device_id: device.id
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error]).to include("Invalid VAST")
      end

      it "respects floor price" do
        mock_dsp_request(build_dsp_response(price: 3.0)) # Below floor price

        post "/api/v1/bid_requests",
             params: default_bid_request_params(
               ad_unit_id: ad_unit.id,
               device_id: device.id
             ),
             as: :json,
             headers: auth_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:error]).to include("No valid bids")
      end
    end
  end
end
