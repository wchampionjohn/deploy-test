# frozen_string_literal: true

namespace :onetime do
  desc "fetch devices from lookr"
  task :fetch_devices, [] => :environment do
    DevicesSyncJob.perform_now
  end
end
