module Hcp
  # One stop of a job, which Housecall Pro calls an appointment: it is booked at the job's
  # place and says what the job says.
  class Visit < Company::Visit
    # The node keys Housecall Pro spells otherwise than the vocabulary.
    def self.keys = { starts_at: :start_time, ends_at: :end_time }

    # @return [Location, nil] where the stop happens: where its job does.
    def location = record Location, :location
  end
end
