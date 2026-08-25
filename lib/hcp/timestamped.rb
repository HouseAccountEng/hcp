module Hcp
  # Extends a record Housecall Pro stamps with when it was opened and last changed.
  module Timestamped
    # @return [Time, nil] when the record was opened.
    def created_at = time 'created_at'

    # @return [Time, nil] when the record last changed.
    def updated_at = time 'updated_at'
  end
end
