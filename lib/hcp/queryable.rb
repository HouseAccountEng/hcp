module Hcp
  # Extends a resource with the entry points that read a list of it, or one record.
  module Queryable
    # @param company_id [String, nil] the location to read as, where the account has several.
    # @return [Relation] every record of this kind the location holds.
    def all(company_id: nil) = Relation.new type: self, company_id: company_id

    # @return [Relation] the records matching these conditions.
    def where(company_id: nil, **conditions) = all(company_id: company_id).where(**conditions)

    # @return [Relation] the records in this order.
    def order(company_id: nil, **sorts) = all(company_id: company_id).order(**sorts)

    # @return [Relation] at most this many records.
    def limit(count, company_id: nil) = all(company_id: company_id).limit(count)

    # @return [Relation] the records, with these brought back beside each of them.
    def includes(*names, company_id: nil) = all(company_id: company_id).includes(*names)

    # @return [Resource] the record Housecall Pro files under this ID.
    def find(id, company_id: nil) = all(company_id: company_id).find(id)

    # What a list of these may be narrowed by, ordered by, and asked to bring back.
    def filters = self::FILTERS
    def many = self::MANY
    def sorts = self::SORTS
    def expands = self::EXPANDS
  end
end
