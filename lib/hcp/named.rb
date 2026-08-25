module Hcp
  # Extends a record Housecall Pro holds a person's names for.
  module Named
    # @return [String] what they are called, by whichever of their names Housecall Pro holds.
    def name = [ @node['first_name'], @node['last_name'] ].compact_blank.join ' '
  end
end
