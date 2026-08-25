module Hcp
  # A pro on a Housecall Pro account.
  class Employee < Resource
    include Timestamped

    # @return [String] what the pro is called, by whichever of their names Housecall Pro holds.
    def name = [ @node['first_name'], @node['last_name'] ].compact_blank.join ' '

    # @return [String, nil] the pro's email address.
    def email = @node['email']

    # @return [String, nil] the pro's mobile number.
    def phone = @node['mobile_number']

    # @return [String, nil] what the pro may do on the account.
    def role = @node['role']
  end
end
