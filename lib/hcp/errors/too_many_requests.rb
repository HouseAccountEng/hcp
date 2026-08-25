module Hcp
  # Raised where Housecall Pro refuses a request for rate.
  class TooManyRequests < Error
    # @param message [String] what Housecall Pro said.
    # @param reset_at [Time, nil] when it will answer again.
    def initialize(message, reset_at)
      super message
      @reset_at = reset_at
    end

    # Nothing here sleeps: a caller with a queue can bring the whole job back, which is worth
    # more than a worker asleep holding a connection open.
    # @return [Time, nil] when the limit lifts, where Housecall Pro said.
    attr_reader :reset_at
  end
end
