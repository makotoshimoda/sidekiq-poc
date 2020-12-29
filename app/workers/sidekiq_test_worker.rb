# frozen_string_literal: true

class SidekiqTestWorker < BaseWorker
  sidekiq_throttle({
                     # Allow maximum 2 concurrent jobs of this class at a time.
                     concurrency: { limit: 2 },
                     # Allow maximum 1K jobs being processed within one hour window.
                     threshold: { limit: 1_000, period: 1.hour }
                   })

  # Test sidekiq throttle/progress/cancel.
  #
  # ==== Returns
  # * <tt>void</tt>.
  # rubocop:disable Rails/Output
  def perform
    return if cancelled?

    objects = [*1..200]
    total objects.count
    objects.each_with_index do |object, index|
      # Track the progress
      at(index + 1, "Processing object #{object}")
      puts "Object #{object}"
      sleep(1)

      break if cancelled?
    end

    return if cancelled?
  end
  # rubocop:enable Rails/Output
end
