class NotifyDspJob < ApplicationJob
  queue_as :default

  def perform(ad_request_id, notification_type)
    ad_request = AdRequest.find(ad_request_id)
    url = notification_type == :nurl ? ad_request.nurl : ad_request.burl

    response = HTTParty.get(url)

    if response.success?
      ad_request.update(
        notification_status: :completed,
        notified_at: Time.current
      )
    else
      ad_request.update(notification_status: :failed)
      # maybe retry
    end
  rescue StandardError => e
    ad_request.update(notification_status: :failed)
    Rails.logger.error("Failed to notify DSP: #{e.message}")
  end
end
