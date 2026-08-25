module Hcp
  # When work is booked for, and how long a window the customer was given.
  class Schedule < Resource
    # @return [Time, nil] when the work is booked to start.
    def starts_at = time 'scheduled_start'

    # @return [Time, nil] when the work is booked to end.
    def ends_at = time 'scheduled_end'

    # The zone the work happens in, which is the one to show a customer a time in.
    # @return [String, nil] an IANA zone name.
    def time_zone = @node['time_zone']

    # @return [Integer, nil] how many minutes wide the arrival window is.
    def arrival_window = @node['arrival_window']
  end
end
