module Hcp
  # The business behind a key: the account, or one location of a franchise.
  class Business < Company::Business
    # The node keys Housecall Pro spells otherwise than the vocabulary.
    def self.keys = { phone: :phone_number }

    # Itself first, then every location under it at any depth, in the order Housecall Pro
    # lists them: a single company is its own one subsidiary, and a franchise reads flat.
    # @return [Array<Business>] locations whose IDs `company_id:` takes, this one included.
    def subsidiaries = [ self, *records(Business, :locations).flat_map(&:subsidiaries) ]
  end
end
