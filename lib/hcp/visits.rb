module Hcp
  # The visits of one location, which Housecall Pro calls appointments and files inside jobs:
  # they are read off the jobs booked across a window, a page of jobs at a time.
  class Visits
    include Enumerable

    # @param client [Client] how to reach Housecall Pro as the location.
    # @param from [Time, nil] the moment the window opens, or nothing for every visit there was.
    # @param to [Time, nil] the moment the window closes, or nothing for every visit to come.
    def initialize(client:, from: nil, to: nil)
      @client = client
      @from = from
      @to = to
    end

    # @param within [ActiveSupport::Duration] how far ahead to look.
    # @return [Visits] the same list, narrowed to the visits booked to start from now on and
    #   that far ahead at most.
    def upcoming(within)
      now = Time.now
      self.class.new client: @client, from: now, to: now + within
    end

    # A job booked across the window carries every visit in it, so the jobs are read once and
    # a canceled job's visits are left where they are.
    # @yield [Visit] each visit in the window, in the order Housecall Pro lists them.
    def each
      jobs.each do |job|
        next if job.canceled?

        job.visits.each { |visit| yield visit if window.cover? visit.starts_at }
      end
    end

  private

    # Open at either end where the list was not narrowed there.
    def window = @from..@to

    def jobs
      bounds = { scheduled_end_min: @from&.utc&.iso8601, scheduled_start_max: @to&.utc&.iso8601 }
      Jobs.new client: @client, params: bounds.compact.merge(expand: [ 'appointments' ])
    end
  end
end
