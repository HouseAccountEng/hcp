module Hcp
  # What Housecall Pro answered: the body it carries, or the refusal it stands for.
  class Answer
    # @param response [Net::HTTPResponse] what Housecall Pro sent back.
    def initialize(response)
      @response = response
    end

    # @return [Hash, nil] record Housecall Pro answered with, or nothing where it sent none.
    def body
      case @response
        when Net::HTTPSuccess then parsed
        when Net::HTTPTooManyRequests then raise TooManyRequests, message
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

    # A PUT is answered with no body at all.
    def parsed = @parsed ||= (JSON @response.body if @response.body.present?)
  end
end
