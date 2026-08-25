module Hcp
  # One line of what a job or an estimate option comes to.
  class LineItem < Resource
    # Housecall Pro answers a job's line items under `data` rather than under their own name.
    def self.key = 'data'

    # @return [String, nil] what the line is called.
    def name = @node['name']

    # @return [String, nil] what the line is, in the words whoever wrote it used.
    def description = @node['description']

    # @return [Float, nil] how many of it.
    def quantity = @node['quantity']

    # @return [BigDecimal, nil] what one of it is charged at.
    def unit_price = money 'unit_price'

    # @return [BigDecimal, nil] what one of it costs the pro.
    def unit_cost = money 'unit_cost'

    # @return [BigDecimal, nil] what the line comes to.
    def amount = money 'amount'

    # @return [Symbol, nil] :materials, :labor, or one of the gratuities and discounts.
    def kind = @node['kind']&.tr(' ', '_')&.to_sym
  end
end
