# frozen_string_literal: true

set :environment, 'development'
set :output, { error: 'log/cron_error_log.log', standard: 'log/cron_log.log' }
every 1.day, at: '14:35 pm' do
  rake 'sidekiq:test_worker'
end
