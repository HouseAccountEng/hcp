module Hcp
  # Where a customer is billed, or where the work happens.
  class Address < Resource
    # What Housecall Pro calls a page of a customer's addresses.
    def self.key = 'addresses'

    # Where the address is, as Housecall Pro holds it.
    attributes :street, :street_line_2, :city, :state, :zip, :country

    # @return [Symbol, nil] :billing or :service.
    def type = @node['type']&.to_sym
  end
end
