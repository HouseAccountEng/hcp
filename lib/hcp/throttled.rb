module Hcp
  # Raised where Housecall Pro refuses a request for rate, and answers it again a little later.
  Throttled = Class.new Company::Throttled
end
