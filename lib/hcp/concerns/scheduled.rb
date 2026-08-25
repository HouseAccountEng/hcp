module Hcp
  # Extends a record Housecall Pro books work for and stamps as the work happens.
  module Scheduled
    # @return [Schedule, nil] when the work is booked for.
    def schedule = record Schedule, 'schedule'

    # @return [Time, nil] when the pro said they were on their way.
    def on_my_way_at = time 'work_timestamps', 'on_my_way_at'

    # @return [Time, nil] when the work started.
    def started_at = time 'work_timestamps', 'started_at'

    # @return [Time, nil] when the work was finished.
    def completed_at = time 'work_timestamps', 'completed_at'
  end
end
