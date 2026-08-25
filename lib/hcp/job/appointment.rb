module Hcp
  # One visit a job is booked for, where the work takes more than a single trip.
  class Job::Appointment < Resource
    # What Housecall Pro calls a list of them.
    def self.key = 'appointments'

    # @return [Time, nil] when the visit is booked to start.
    def starts_at = time 'start_time'

    # @return [Time, nil] when the visit is booked to end.
    def ends_at = time 'end_time'

    # @return [Boolean] whether the visit is booked for a day rather than for a time.
    def anytime? = @node['anytime']

    # @return [Integer, nil] how many minutes wide the arrival window is.
    def arrival_window = @node['arrival_window_minutes']

    # @return [Array<String>] the IDs of the pros sent on the visit.
    def dispatched_employee_ids = Array(@node['dispatched_employees_ids'])
  end
end
