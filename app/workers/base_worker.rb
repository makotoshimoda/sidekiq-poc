# frozen_string_literal: true

class BaseWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include Sidekiq::Throttled::Worker

  # Check if the job was cancelled
  def cancelled?
    Sidekiq.redis { |c| c.exists?("cancelled-#{jid}") }
  end

  # Cancel a job
  def self.cancel!(jid)
    Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86_400, 1) }
  end
end
