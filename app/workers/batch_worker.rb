# frozen_string_literal: true

class BatchWorker < BaseWorker
  sidekiq_throttle({
                     # Allow maximum 2 concurrent jobs of this class at a time.
                     concurrency: { limit: 2 },
                     # Allow maximum 1K jobs being processed within one hour window.
                     threshold: { limit: 1_000, period: 1.hour }
                   })

  # Callback function.
  #
  # ==== Returns
  # * <tt>void</tt>.
  # rubocop:disable Rails/Output
  def on_complete(status, _params)
    puts "#{status.total} was processed"
  end
  # rubocop:enable Rails/Output

  # Test sidekiq batch/callback.
  #
  # ==== Returns
  # * <tt>void</tt>.
  # rubocop:disable Metrics/MethodLength
  def perform
    return if cancelled?

    objects = [*1..200]
    batch = Sidekiq::Batch.new
    batch.on(:complete, 'BatchWorker')
    total objects.count
    batch.jobs do
      objects.each_with_index do |object, index|
        at(index + 1, "Processing object #{object}")
        PrintWorker.perform_async(object, index)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
