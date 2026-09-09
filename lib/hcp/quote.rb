module Hcp
  # A price a Housecall Pro user sent, which Housecall Pro calls an estimate.
  class Quote < Company::Quote
    # @param node [Hash] estimate as Housecall Pro named it beside a job: its ID alone.
    # @param client [Client] how to reach Housecall Pro for the rest of it.
    def initialize(node: {}, client:)
      super node: node
      @client = client
    end

    # Housecall Pro prices an estimate by options and names it beside a job by ID alone, so
    # what it comes to is read off the estimate itself on the first ask: the total of the
    # option the customer approved, in dollars.
    # @return [BigDecimal, nil] what the approved option comes to, nil where none is approved.
    def amount = approved && BigDecimal(approved['total_amount'].to_s) / 100

  private

    def approved = options.find { |option| option['approval_status'] == 'approved' }

    def options = estimate.fetch 'options'

    def estimate = @estimate ||= @client.get("estimates/#{id}")
  end
end
