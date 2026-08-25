module Hcp
  # One read from Housecall Pro.
  class Request
    # Where Housecall Pro answers.
    HOST = 'https://api.housecallpro.com'

    # @param path [String] what to read, under the host.
    # @param params [Hash] the query to read it with.
    # @param company_id [String, nil] the location to read it as.
    def initialize(path:, params: {}, company_id: nil)
      @path = path
      @params = params
      @company_id = company_id
    end

    # @return [Hash] what Housecall Pro answered.
    def body = Answer.new(Net::HTTP.get_response(uri, headers)).body

  private

    def uri = URI [ "#{HOST}/#{@path}", @params.compact.to_query ].compact_blank.join '?'

    def headers
      {
        'Authorization' => "Token #{Hcp.key}",
        'Content-Type' => 'application/json',
        'X-Company-Id' => @company_id,
      }.compact
    end
  end
end
