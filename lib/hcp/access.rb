module Hcp
  # What a key opens: the account it belongs to, read as one of its locations.
  class Access
    # @param company_id [String, nil] the location to read as, where the account has several.
    def initialize(company_id: nil)
      @company_id = company_id
    end

    # @return [Company] the account the key belongs to, as the location it is read as.
    def account = Company.current company_id: @company_id
  end
end
