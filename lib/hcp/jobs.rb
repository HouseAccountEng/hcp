module Hcp
  # The jobs of one location, walked a page at a time.
  class Jobs < Company::Collection
    # Jobs a page: the most Housecall Pro answers with, and more than it refuses.
    PAGE = 200

    # @param client [Client] how to reach Housecall Pro as the location.
    # @param params [Hash] what the list is narrowed to, as Housecall Pro filters jobs.
    def initialize(client:, params: {})
      @client = client
      @params = params
    end

    # @param from [Time, nil] the moment the window opens, or nothing for as far back as it goes.
    # @param to [Time, nil] the moment the window closes, or nothing for as far ahead as it goes.
    # @return [Jobs] the same list, narrowed to the jobs booked to start between the two.
    def between(from, to)
      bounds = { scheduled_start_min: from&.utc&.iso8601, scheduled_start_max: to&.utc&.iso8601 }
      self.class.new client: @client, params: bounds.compact
    end

    # Nothing is read until the walk starts, and a page only once the one before it runs out.
    # @yield [Job] each job in the window, in the order Housecall Pro lists them.
    def each
      (1..).each do |page|
        body = @client.get 'jobs', @params.merge(page: page, page_size: PAGE)
        body.fetch('jobs').each { |node| yield Job.new node: node, client: @client }
        break if page >= body.fetch('total_pages')
      end
    end
  end
end
