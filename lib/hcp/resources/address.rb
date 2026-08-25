module Hcp
  # Where a customer is billed, or where the work happens.
  class Address < Resource
    # What Housecall Pro calls a page of a customer's addresses.
    def self.key = 'addresses'

    attribute :street
    attribute :street_line_2
    attribute :city
    attribute :state
    attribute :zip
    attribute :country

    # @return [Float, nil] how far north the address is, where Housecall Pro placed it.
    attribute :latitude

    # @return [Float, nil] how far east the address is, where Housecall Pro placed it.
    attribute :longitude

    # @return [Symbol, nil] :billing or :service.
    def type = @node['type']&.to_sym
  end
end
