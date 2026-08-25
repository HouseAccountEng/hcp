module Hcp
  # Every record of one kind a Housecall Pro account holds, walked a page at a time.
  class Relation
    include Chainable, Enumerable

    # Records a page: the most Housecall Pro answers with, and more than it refuses.
    PAGE = 200

    # @param type [Class] what each record is read as.
    # @param path [String] where Housecall Pro keeps them, under the host.
    # @param company_id [String, nil] the location to read them as.
    def initialize(type:, path: nil, company_id: nil, conditions: {}, sorts: {}, limit: nil,
      expands: [])
      @type = type
      @path = path || type.path
      @company_id = company_id
      @conditions = conditions
      @sorts = sorts
      @limit = limit
      @expands = expands
    end

    # Nothing is read until the walk starts, and a page only once the one before it runs out.
    # @return [Enumerator, Relation] every record the list holds, or the list once walked.
    def each(&block)
      return walk unless block

      walk.each(&block)
      self
    end

    # Shadows Enumerable#find the way Active Record does: a record is reached by the ID
    # Housecall Pro files it under, not by asking every record whether it is the one.
    # @param id [String] the Housecall Pro ID.
    # @return [Resource] the record, raising Hcp::NotFound where there is none.
    def find(id) = record_for read("#{@path}/#{id}")

    # A page of one carries the total beside it, so this is one small read however long the
    # list is.
    # @return [Integer] how many records the list holds.
    def count = @count ||= [ read(@path, page_size: 1)['total_items'], @limit ].compact.min

  private

    def walk
      Enumerator.new do |yielder|
        seen = 0
        (1..).each do |page|
          body = read @path, page: page, page_size: [ @limit, PAGE ].compact.min
          body.fetch(@type.key).each do |node|
            yielder << record_for(node)
            break if (seen += 1) == @limit
          end
          break if seen == @limit || page >= body.fetch('total_pages', page)
        end
      end
    end

    def read(path, paging = {})
      Request.new(path: path, params: params.merge(paging), company_id: @company_id).body
    end

    def params
      @conditions.flat_map { |name, value| filter(name, value).to_a }.to_h.
        merge sort_by: @sorts.keys.first, sort_direction: @sorts.values.first,
          expand: @expands.presence
    end

    def filter(name, value)
      bounds = @type.filters.fetch name
      Filter.new(bounds: bounds, value: @type.many.include?(name) ? Array(value) : value).params
    end

    def record_for(node) = @type.new node: node, company_id: @company_id
  end
end
