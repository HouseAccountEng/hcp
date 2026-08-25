module Hcp
  # What Housecall Pro answered: the body it carries, or the refusal it stands for.
  class Answer
    # The header Housecall Pro names the epoch a rate limit lifts at.
    RESET_HEADER = 'RateLimit-Reset'

    # @param response [Net::HTTPResponse] what Housecall Pro sent back.
    def initialize(response)
      @response = response
    end

    # @return [Hash] the record or page Housecall Pro answered with.
    def body
      case @response
        when Net::HTTPSuccess then parsed
        when Net::HTTPNotFound then raise NotFound, message
        when Net::HTTPTooManyRequests then raise TooManyRequests.new(message, reset_at)
        else raise Error, message
      end
    end

  private

    # Housecall Pro writes a refusal three ways: the message under an `error`, the message as
    # the `error`, and the message on its own.
    def message
      error = parsed['error'] || parsed['message']
      error.is_a?(Hash) ? error['message'] : error
    end

    def reset_at = (Time.at Integer(@response[RESET_HEADER]) if @response[RESET_HEADER])

    def parsed = @parsed ||= JSON(@response.body)
  end
end
