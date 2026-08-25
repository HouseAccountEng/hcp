module Hcp
  # Whoever the work is for.
  class Customer < Resource
    extend Queryable
    include Named, Timestamped

    # A customer is narrowed by one free-text search rather than by named fields.
    FILTERS = { q: %i[q], location_ids: %i[location_ids] }

    # The conditions Housecall Pro takes more than one of, and refuses one of.
    MANY = %i[location_ids]

    # What Housecall Pro will put a list of customers in order of.
    SORTS = %i[created_at updated_at]

    # What a customer brings back beside themselves where they are asked to.
    EXPANDS = %i[attachments do_not_service]

    # Where Housecall Pro keeps them.
    def self.path = 'customers'

    # What Housecall Pro calls a page of them.
    def self.key = 'customers'

    attribute :first_name
    attribute :last_name
    attribute :email

    # @return [String, nil] the business the customer is, where they are one.
    attribute :company

    # @return [String, nil] where the customer came from.
    attribute :lead_source


    # Housecall Pro holds three numbers, and a caller wants whichever one there is.
    # @return [String, nil] the number the customer is reached on first.
    def phone = @node['mobile_number'] || @node['home_number'] || @node['work_number']

    # @return [Symbol, nil] :homeowner, or whatever else Housecall Pro takes the customer for.
    def kind = @node['kind']&.to_sym

    # @return [Boolean] whether the customer agreed to hear from the pro.
    def notifications_enabled? = @node['notifications_enabled']

    # @return [Array<String>] what the customer is tagged with.
    def tags = Array(@node['tags'])

    # @return [Relation] every address the customer is billed or served at.
    def addresses = nested Address, 'addresses'
  end
end
