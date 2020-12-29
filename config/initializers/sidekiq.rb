# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq/throttled'
require 'sidekiq_queue_metrics'

Sidekiq::Throttled.setup!

configuration = {
  url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}",
  namespace: "#{Rails.env}_video_store_sidekiq"
}
configuration[:password] = ENV['REDIS_PASS'] if ENV['REDIS_PASS'].present?

Sidekiq.configure_server do |config|
  config.redis = configuration

  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes

  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes

  Sidekiq::QueueMetrics.init(config)
end

Sidekiq.configure_client do |config|
  config.redis = configuration

  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end
