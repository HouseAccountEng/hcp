module Hcp
  # One line of what a job comes to.
  class Line < Company::Line
    # Housecall Pro counts in cents, and a caller reads dollars.
    # @return [BigDecimal, nil] what the line comes to.
    def amount = (cents = super) && cents / 100
  end
end
