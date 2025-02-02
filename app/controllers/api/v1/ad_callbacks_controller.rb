# app/controllers/api/v1/ad_callbacks_controller.rb
module Api
  module V1
    class AdCallbacksController < ApplicationController
      skip_before_action :verify_authenticity_token

      # Device 下載素材成功的回調
      def creative_loaded
        ad_request = AdRequest.find(params[:ad_request_id])
        ad_request.update(notification_status: :creative_loaded)

        # 通知 DSP 廣告已下載成功
        ad_request.notify_dsp_win

        render json: { status: "ok" }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Ad request not found" }, status: :not_found
      end

      # Device 播放完成的回調
      def burl
        ad_request = AdRequest.find(params[:ad_request_id])
        ad_request.update(notification_status: :burl_received)

        # 通知 DSP 廣告已播放完成
        ad_request.notify_dsp_billing

        render json: { status: "ok" }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Ad request not found" }, status: :not_found
      end
    end
  end
end
