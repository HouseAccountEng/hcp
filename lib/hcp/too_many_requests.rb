module Hcp
  # Raised where Housecall Pro refuses a request for rate. Nothing here sleeps: a caller with a
  # queue can bring the whole job back, which is worth more than a worker asleep holding a
  # connection open.
  TooManyRequests = Class.new Error
end
