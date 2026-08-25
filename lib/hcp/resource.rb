module Hcp
  # A record as Housecall Pro answered it.
  class Resource
    # @param node [Hash] the record as Housecall Pro answered it.
    # @param company_id [String, nil] the location it was read as.
    def initialize(node: {}, company_id: nil)
      @node = node
      @company_id = company_id
    end

    # @return [String] the ID Housecall Pro files the record under.
    def id = @node['id']

  private

    # Built from the record's own path rather than its class, so a nested collection sits
    # under its parent however deep Housecall Pro put it.
    def nested(type, segment)
      Relation.new type: type, path: "#{path}/#{segment}", company_id: @company_id
    end

    def path = "#{self.class.path}/#{id}"

    def time(*keys)
      value = @node.dig(*keys)
      Time.iso8601 value if value.present?
    end

    # Housecall Pro counts money in cents, and a caller reads it in dollars.
    def money(key) = (BigDecimal(@node[key].to_s) / 100 if @node[key])

    def record(type, key) = (type.new node: @node[key], company_id: @company_id if @node[key])

    def records(type, key)
      Array(@node[key]).map { |node| type.new node: node, company_id: @company_id }
    end
  end
end
