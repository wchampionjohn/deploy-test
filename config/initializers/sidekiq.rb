# frozen_string_literal: true

require "sidekiq"
require "sidekiq-scheduler"
require "sidekiq/web"

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://127.0.0.1:6379/15" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://127.0.0.1:6379/15" }
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file("config/sidekiq_scheduler.yml") || []
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
  # define a new capsule which processes jobs from the `unsafe` queue one at a time
  config.capsule("unsafe") do |cap|
    cap.concurrency = 5
    cap.queues = %w[unsafe]
  end
end
