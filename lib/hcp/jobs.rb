module Hcp
  # The jobs of one location, walked a page at a time.
  class Jobs
    include Enumerable

    # Jobs a page: the most Housecall Pro answers with, and more than it refuses.
    PAGE = 200

    # @param client [Client] how to reach Housecall Pro as the location.
    # @param window [Hash] when the jobs are booked to start, as Housecall Pro filters them.
    def initialize(client:, window: {})
      @client = client
      @window = window
    end

    # @param within [ActiveSupport::Duration] how far back to look.
    # @return [Jobs] the same list, narrowed to the jobs booked to start that long ago at most
    #   and before now.
    def past(within)
      now = Time.now
      self.class.new client: @client, window: { scheduled_start_min: (now - within).utc.iso8601,
                                                scheduled_start_max: now.utc.iso8601, }
    end

    # Nothing is read until the walk starts, and a page only once the one before it runs out.
    # @yield [Job] each job in the window, in the order Housecall Pro lists them.
    def each
      (1..).each do |page|
        body = @client.get 'jobs', @window.merge(page: page, page_size: PAGE)
        body.fetch('jobs').each { |node| yield Job.new node: node, client: @client }
        break if page >= body.fetch('total_pages')
      end
    end
  end
end
