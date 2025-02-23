# frozen_string_literal: true

require "sidekiq"
require "sidekiq-scheduler"
require "sidekiq/web"

def redis_url
  @redis_url ||=
    begin
      rails_root = ENV["RAILS_ROOT"] || File.dirname(__FILE__) + "/../.."
      rails_env = Rails.env || "development"
      redis_host = YAML.load_file(rails_root + "/config/redis.yml")
      redis_host[rails_env]
    end
end


Sidekiq.configure_client do |config|
  config.redis = { url: "redis://conector-api-redis:6379/15" }
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://conector-api-redis:6379/15}" }
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
