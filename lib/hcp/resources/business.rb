module Hcp
  # The business behind a key: the account, or one location of a franchise.
  class Business < Company::Business
    # The node keys Housecall Pro spells otherwise than the vocabulary.
    def self.keys = { phone: :phone_number }

  private

    # Housecall Pro lists the locations under a business only to an application key.
    def below = records Business, :locations
  end
end
