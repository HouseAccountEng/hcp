module Hcp
  # The service zones of one location, walked a page at a time.
  class Areas < Company::Collection
    # Zones a page: the most Housecall Pro answers a list with, where its default is ten.
    PAGE = 200

    # @param client [Client] how to reach Housecall Pro as the location.
    def initialize(client:)
      @client = client
    end

    # Nothing is read until the walk starts, and a page only once the one before it runs out.
    # @yield [Area] each zone, in the order Housecall Pro lists them.
    def each
      (1..).each do |page|
        body = @client.get 'service_zones', page: page, page_size: PAGE
        body.fetch('service_zones').each { |node| yield Area.new node: node }
        break if page >= body.fetch('total_pages')
      end
    end
  end
end
