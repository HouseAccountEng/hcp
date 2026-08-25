module Hcp
  # Whoever the work is for.
  class Customer < Resource
    extend Queryable
    include Timestamped

    # A customer is narrowed by one free-text search rather than by named fields.
    FILTERS = { q: %i[q], location_ids: %i[location_ids] }

    # The conditions Housecall Pro takes more than one of, and refuses one of.
    MANY = %i[location_ids]

    # What Housecall Pro will put a list of customers in order of.
    SORTS = %i[created_at updated_at]

    # What a customer brings back beside themselves where they are asked to.
    EXPANDS = %i[attachments do_not_service]

    # Where Housecall Pro keeps them, and what it calls a page of them.
    def self.path = 'customers'
    def self.key = 'customers'

    # @return [String] what the customer is called, by whichever names Housecall Pro holds.
    def name = [ @node['first_name'], @node['last_name'] ].compact_blank.join ' '

    # @return [String, nil] the customer's first name.
    def first_name = @node['first_name']

    # @return [String, nil] the customer's last name.
    def last_name = @node['last_name']

    # @return [String, nil] the customer's email address.
    def email = @node['email']

    # @return [String, nil] the number the customer is reached on first.
    def phone = @node['mobile_number'] || @node['home_number'] || @node['work_number']

    # @return [String, nil] the business the customer is, where they are one.
    def company = @node['company']

    # @return [Symbol, nil] :homeowner, or whatever else Housecall Pro takes the customer for.
    def kind = @node['kind']&.to_sym

    # @return [Boolean] whether the customer agreed to hear from the pro.
    def notifications_enabled? = @node['notifications_enabled']

    # @return [String, nil] where the customer came from.
    def lead_source = @node['lead_source']

    # @return [Array<String>] what the customer is tagged with.
    def tags = Array(@node['tags'])

    # @return [Relation] every address the customer is billed or served at.
    def addresses = nested Address, 'addresses'
  end
end
