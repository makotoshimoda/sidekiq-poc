# frozen_string_literal: true

class PrintWorker < BaseWorker
  # Print the object.
  #
  # ==== Returns
  # * <tt>void</tt>.
  # rubocop:disable Rails/Output
  def perform(object, _index)
    puts "Object #{object}"
  end
  # rubocop:enable Rails/Output
end
