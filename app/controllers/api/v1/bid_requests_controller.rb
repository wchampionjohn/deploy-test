module Api
  module V1
    class BidRequestsController < ApplicationController
      skip_before_action :verify_authenticity_token
      allow_unauthenticated_access only: :create

      def create
        validate_params!
        processor = BidRequestProcessor.new(build_ad_request)
        Rails.logger.info("Bid request: #{processor.inspect}")
        bid_response = processor.process
        Rails.logger.info("Bid response: #{bid_response.inspect}")
        render json: bid_response, status: :ok
      rescue ArgumentError => e
        Rails.logger.error("ArgumentError: #{e.message}")
        render json: { error: e.message }, status: :unprocessable_entity
      rescue Timeout::Error => e
        Rails.logger.error("Timeout Error")
        render json: { error: "DSP request timeout" }, status: :unprocessable_entity
      rescue StandardError => e
        Rails.logger.error("Bid request error: #{e.message}\n#{e.backtrace.join("\n")}")
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def validate_params!
        unless bid_params[:ad_unit_id].present? && bid_params[:device_id].present?
          raise ArgumentError, "Missing required parameters"
        end

        @ad_unit = AdUnit.find(bid_params[:ad_unit_id])
        @device = Device.find(bid_params[:device_id])
      rescue ActiveRecord::RecordNotFound => e
        raise ArgumentError, "Invalid #{e.model.underscore.humanize.downcase}"
      end

      def build_ad_request
        # 從請求中獲取預計播放時間，如果沒有提供則使用當前時間
        display_time = Time.at(bid_params[:dt].to_i) if bid_params[:dt]

        # 先創建 AdRequest 實例但不保存
        ad_request = AdRequest.new(
          ad_unit: @ad_unit,
          device: @device,
          ip_address: bid_params[:ip],
          user_agent: bid_params[:user_agent],
          processed_at: bid_params[:timestamp],
          geo_location: bid_params[:geo],
          estimated_display_time: display_time,
          applied_multiplier: @ad_unit.get_multiplier_for_time(display_time),
          notification_status: :pending
        )

        # 使用 ad_request 實例來建立 bid_request
        ad_request.bid_request = OpenRtbBuilder.new(ad_request).build
        ad_request.save!
        ad_request
      end

      def bid_params
        params.require(:bid_request).permit(
          :ad_unit_id, :device_id, :ip, :user_agent, :timestamp, :dt,
          geo: [ :lat, :lon ]
        )
      end
    end
  end
end
