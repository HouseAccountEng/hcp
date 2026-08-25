module Hcp
  # When work is booked for, and how long a window the customer was given.
  class Schedule < Resource
    # When the work is booked to start and to end.
    timestamp :starts_at, :scheduled_start
    timestamp :ends_at, :scheduled_end

    # The zone to show a customer a time in, and how many minutes wide their window is.
    attributes :time_zone, :arrival_window
  end
end
