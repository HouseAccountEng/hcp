module Hcp
  # Extends a record Housecall Pro moves through a workflow.
  module Statused
    # Housecall Pro narrows a list by one set of words and answers with another, so a caller
    # who filters by :in_progress reads :in_progress back rather than 'in progress'.
    STATUSES = {
      'needs scheduling' => :unscheduled,
      'scheduled' => :scheduled,
      'in progress' => :in_progress,
      'complete rated' => :completed,
      'complete unrated' => :completed,
      'user canceled' => :canceled,
      'pro canceled' => :canceled,
    }

    # @return [Symbol, nil] where Housecall Pro files the record in its own workflow.
    def work_status = STATUSES[@node['work_status']]

    # A rating is not a status, so it reads beside one rather than inside it.
    # @return [Boolean] whether the customer rated the work.
    def rated? = @node['work_status'] == 'complete rated'
  end
end
