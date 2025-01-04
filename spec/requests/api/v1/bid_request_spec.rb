require 'rails_helper'

RSpec.describe "Api::V1::BidRequests", type: :request do
  let(:ad_space) { create(:ad_space, floor_price: 5.0) }
  let(:ad_unit) { create(:ad_unit, ad_space: ad_space) }
  let(:device) { create(:device) }

  describe "POST /api/v1/bid_requests" do
    context "with valid parameters" do
      it "processes a regular bid request successfully" do
        mock_dsp_request(build_dsp_response(price: 10.0))

        post "/api/v1/bid_requests",
          params: default_bid_request_params(
            ad_unit_id: ad_unit.id,
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
    end

    context "with invalid parameters" do
      it "returns error for missing ad_unit_id" do
        params = default_bid_request_params(device_id: device.id)
        params[:bid_request].delete(:ad_unit_id)

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
            ad_unit_id: ad_unit.id,
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
