module Hcp
  # One visit a job is booked for, where the work takes more than a single trip.
  class Job::Appointment < Resource
    # What Housecall Pro calls a list of them.
    def self.key = 'appointments'

    # When the visit is booked to start and to end.
    timestamp :starts_at, :start_time
    timestamp :ends_at, :end_time

    # How many minutes wide the arrival window is.
    attribute :arrival_window, :arrival_window_minutes

    # @return [Boolean] whether the visit is booked for a day rather than for a time.
    def anytime? = @node['anytime']

    # @return [Array<String>] the IDs of the pros sent on the visit.
    def dispatched_employee_ids = Array(@node['dispatched_employees_ids'])
  end
end
