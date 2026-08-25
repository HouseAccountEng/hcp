module Hcp
  # One line of what a job or an estimate option comes to.
  class LineItem < Resource
    # Housecall Pro answers a job's line items under `data` rather than under their own name.
    def self.key = 'data'

    # What the line is, and how many of it.
    attributes :name, :description, :quantity

    # What the line is charged at, what it costs the pro, and what it comes to.
    amounts :unit_price, :unit_cost, :amount

    # @return [Symbol, nil] :materials, :labor, or one of the gratuities and discounts.
    def kind = @node['kind']&.tr(' ', '_')&.to_sym
  end
end
