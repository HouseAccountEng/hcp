module Hcp
  # Where the work happens: the address Housecall Pro books a job at.
  class Location < Company::Location
    # @return [Customer, nil] whose place it is, as Housecall Pro filed them beside the job.
    def customer = record Customer, :customer
  end
end
