module Hcp
  # One line of what a job or an estimate option comes to.
  class LineItem < Resource
    # Housecall Pro answers a job's line items under `data` rather than under their own name.
    def self.key = 'data'

    attribute :name
    attribute :description

    # @return [Float, nil] how many of it, to two decimal places.
    attribute :quantity

    amount :unit_price
    amount :unit_cost
    amount :amount

    # @return [Symbol, nil] :materials, :labor, or one of the gratuities and discounts.
    def kind = @node['kind']&.tr(' ', '_')&.to_sym
  end
end
