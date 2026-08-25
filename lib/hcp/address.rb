module Hcp
  # Where a customer is billed, or where the work happens.
  class Address < Resource
    # Where Housecall Pro keeps a customer's addresses, and what it calls a page of them.
    def self.key = 'addresses'

    # @return [Symbol, nil] :billing or :service.
    def type = @node['type']&.to_sym

    # @return [String, nil] the street, without its second line.
    def street = @node['street']

    # @return [String, nil] the second line of the street, where the address has one.
    def street_line_2 = @node['street_line_2']

    # @return [String, nil] the city.
    def city = @node['city']

    # @return [String, nil] the state.
    def state = @node['state']

    # @return [String, nil] the ZIP code.
    def zip = @node['zip']

    # @return [String, nil] the country.
    def country = @node['country']
  end
end
