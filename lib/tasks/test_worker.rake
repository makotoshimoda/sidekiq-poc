# frozen_string_literal: true

namespace :sidekiq do
  desc 'Run the SidekiqTestWorker'
  task test_worker: :environment do
    SidekiqTestWorker.perform_async
  end
end
