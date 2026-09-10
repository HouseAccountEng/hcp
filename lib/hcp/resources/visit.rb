module Hcp
  # One stop of a job, which Housecall Pro calls an appointment: it happens where the job does
  # and says what the job says.
  class Visit < Company::Visit
    # The node keys Housecall Pro spells otherwise than the vocabulary.
    def self.keys = { starts_at: :start_time, ends_at: :end_time }

    # @param node [Hash] appointment as Housecall Pro answered it under the job's schedule.
    # @param job [Job] job the appointment sits under.
    def initialize(node: {}, job:)
      super node: node
      @job = job
    end

    # @return [Job] job the stop belongs to, which came with it.
    attr_reader :job

    # @return [String, nil] what the job is called: an appointment has no words of its own.
    def description = @job.description
  end
end
