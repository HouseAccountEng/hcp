module Hcp
  # A price a Housecall Pro user sent, which Housecall Pro calls an estimate option: a job names
  # the option it was created from, and an estimate holds one option or several.
  class Quote < Company::Quote
    # @param node [Hash] option as Housecall Pro named it beside a job: its ID, and the customer.
    # @param client [Client] how to reach Housecall Pro for the rest of it.
    def initialize(node: {}, client:)
      super node: node
      @client = client
    end

    # Housecall Pro reads an estimate by its own ID and not by an option's, so the option is
    # found among the customer's estimates, read once on the first ask.
    # @return [BigDecimal, nil] what the option comes to in dollars, nil where none is found.
    def amount = option && BigDecimal(option['total_amount'].to_s) / 100

  private

    def option = options.find { |each| each['id'] == id }

    def options = estimates.flat_map { |estimate| estimate['options'] }

    def estimates
      @estimates ||= @client.get('estimates', customer_id: @node.dig(:customer, :id),
        page_size: Jobs::PAGE).fetch 'estimates'
    end
  end
end
