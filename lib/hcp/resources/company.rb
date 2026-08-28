module Hcp
  # The account a key belongs to, and the settings every job it holds is booked under.
  class Company < Resource
    # Where Housecall Pro keeps it.
    def self.path = 'company'

    # The only company a key can read is its own, so there is no list and no ID to find one by.
    # @param company_id [String, nil] the location to read as, where the account has several.
    # @return [Company] the account, as the location it was read as.
    def self.current(company_id: nil)
      node = Request.new(path: path, company_id: company_id).body
      new node: node, company_id: company_id
    end

    attribute :name
    attribute :website
    attribute :time_zone

    # @return [String, nil] where the account's logo is served from.
    attribute :logo_url

    # @return [String, nil] the number the account is reached on.
    attribute :phone, :phone_number

    # @return [String, nil] the address a customer's reply goes to.
    attribute :support_email

    # @return [Integer, nil] how many minutes wide the window a customer is given is, by default.
    attribute :arrival_window, :default_arrival_window

    # @return [Address, nil] where the account is run from.
    def address = record Address, 'address'

    # @return [Array<String>] the ZIP codes the account will travel to.
    def zip_codes = Array(@node.dig('service_areas_data', 'zip_codes'))

    # A location holds its own, so a franchise arrives as a tree rather than as a flat list.
    # @return [Array<Company>] the locations under this one, whose IDs `company_id:` takes.
    def locations = records Company, 'locations'
  end
end
