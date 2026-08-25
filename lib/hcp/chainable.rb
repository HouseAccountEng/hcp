module Hcp
  # Extends a list with the chaining that narrows, orders and cuts it.
  module Chainable
    # A condition Housecall Pro does not take is one it ignores, answering the whole account
    # rather than a page of it, so an unknown one is refused here where it can still be named.
    # @return [Relation] the same list, narrowed by these conditions.
    def where(**conditions)
      only conditions.keys, @type.filters.keys
      narrowed conditions: @conditions.merge(conditions)
    end

    # @return [Relation] the same list, in this order.
    def order(**sorts)
      only sorts.keys, @type.sorts
      narrowed sorts: sorts
    end

    # @return [Relation] the same list, stopping after this many records.
    def limit(count) = narrowed limit: count

    # @return [Relation] the same list, asking Housecall Pro for these beside each record.
    def includes(*names)
      only names, @type.expands
      narrowed expands: @expands | names
    end

  private

    def only(names, allowed)
      unknown = names - allowed
      raise Error, "#{unknown.first} is not one of: #{allowed.join ', '}" if unknown.any?
    end

    def narrowed(conditions: @conditions, sorts: @sorts, limit: @limit, expands: @expands)
      Relation.new type: @type, path: @path, company_id: @company_id, conditions: conditions,
        sorts: sorts, limit: limit, expands: expands
    end
  end
end
