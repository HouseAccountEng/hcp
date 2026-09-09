module Hcp
  # Every request to Housecall Pro, made with one key as one location.
  class Client
    # Where Housecall Pro answers.
    HOST = 'https://api.housecallpro.com'

    # @param key [String] API key every request is made with.
    # @param company_id [String, nil] location to act as, where the account has several.
    def initialize(key:, company_id: nil)
      @key = key
      @company_id = company_id
    end

    # @return [Hash] record Housecall Pro answered with.
    def get(path, query = {}) = answer { Net::HTTP.get_response uri(path, query), headers }

    # @return [Hash] record Housecall Pro opened.
    def post(path, body) = answer { Net::HTTP.post uri(path), body.to_json, headers }

    # @return [Hash, nil] what Housecall Pro answered, where it answered anything.
    def put(path, body) = answer { Net::HTTP.put uri(path), body.to_json, headers }

  private

    def answer
      Answer.new(yield).body
    rescue Errno::ECONNREFUSED => error
      raise Error, error
    end

    def uri(path, query = {}) = URI [ "#{HOST}/#{path}", query.to_query ].compact_blank.join('?')

    # The account a key belongs to refuses X-Company-Id, so it is only sent for a location.
    def headers
      {
        'Authorization' => "Token #{@key}",
        'Content-Type' => 'application/json',
        'X-Company-Id' => @company_id,
      }.compact
    end
  end
end
