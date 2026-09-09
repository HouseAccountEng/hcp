module Hcp
  # Somebody who asked a Housecall Pro user for work, and where they sit in the pipeline.
  class Lead < Company::Lead
    # @param node [Hash] lead as Housecall Pro answered it.
    # @param client [Client] how to reach Housecall Pro as the lead's location.
    def initialize(node: {}, client:)
      super node: node
      @client = client
    end

    # Housecall Pro files the customer beside the lead rather than by ID.
    # @return [String, nil] ID of the customer opened with the lead.
    def customer_id = @node.dig :customer, :id

    # Moves the lead to the status going by this name. Housecall Pro moves a lead by status ID
    # and names them only by their words, so the status is looked up first.
    # @param status_name [String] status as the account names it, such as 'Won'.
    def update(status_name:)
      status = statuses.find { |each| each['name'] == status_name } || unknown(status_name)
      @client.put 'pipeline/statuses',
        resource_type: 'lead', resource_id: id, status_id: status['id']
    end

  private

    def statuses = @client.get('pipeline/statuses', resource_type: 'lead').fetch 'statuses'

    def unknown(name) = raise Error, "Status #{name} not found for lead #{id}"
  end
end
