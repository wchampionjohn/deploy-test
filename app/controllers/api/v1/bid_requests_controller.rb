# frozen_string_literal: true

module Api
  module V1
    class BidRequestsController < ApplicationController
      skip_before_action :verify_authenticity_token
      allow_unauthenticated_access only: :create

      before_action :find_device, only: :create

      def create
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

      def build_ad_request
        form = ::DSP::AdRequestForm.new(@device, params: bid_params)
        raise ArgumentError, form.errors.full_messages.to_sentence unless form.save
        form.ad_request
      end

      def find_device
        @device = Device.find_by(id: bid_params[:device_id])
        if @device.nil?
          render json: { error: "Device not found: #{bid_params[:device_id]}" }, status: :unprocessable_entity
        end
      end

      def bid_params
        params.require(:bid_request).permit(
          :device_id, :width, :height, :ip, :user_agent, :timestamp, :dt, resolution: [:width, :height],
          geo: [:lat, :lon]
        )
      end
    end
  end
end
