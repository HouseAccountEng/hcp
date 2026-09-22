module Hcp
  # A group of ZIP codes the business serves, which Housecall Pro calls a service zone.
  class Area < Company::Area
    # The node keys Housecall Pro spells otherwise than the vocabulary.
    def self.keys = { zips: :zip_codes }
  end
end
