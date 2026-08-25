module Hcp
  # When work is booked for, and how long a window the customer was given.
  class Schedule < Resource
    # @return [Time, nil] when the work is booked to start.
    timestamp :starts_at, :scheduled_start

    # @return [Time, nil] when the work is booked to end.
    timestamp :ends_at, :scheduled_end

    # @return [String, nil] the IANA zone to show a customer a time in.
    attribute :time_zone

    # @return [Integer, nil] how many minutes wide the arrival window is.
    attribute :arrival_window
  end
end
