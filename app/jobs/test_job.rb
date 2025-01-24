# frozen_string_literal: true

class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "Hello from Sidekiq with args: #{args.inspect}"
  end
end
