module Hcp
  # The leads of one location: who asked a Housecall Pro user for work, before there is a job.
  class Leads
    # @param client [Client] how to reach Housecall Pro as the location.
    def initialize(client:)
      @client = client
    end

    # Opens a lead, and a customer with it, on Housecall Pro.
    # @param name [String] who asked.
    # @param phone [String, nil] number they are reached on.
    # @param email [String, nil] address they are written to.
    # @param address [Hash, nil] where the work would happen, as Housecall Pro takes it.
    # @param note [String, nil] what they said.
    # @param source [String, nil] where the lead came from, as the account names its sources.
    # @return [Lead] lead as Housecall Pro filed it, with its customer's ID beside it.
    def create(name:, phone:, email:, address:, note:, source:)
      customer = { first_name: name, email: email, mobile_number: phone, lead_source: source }
      body = { customer: customer.compact_blank, address: address, lead_source: source, note: note }
      Lead.new node: @client.post('leads', body.compact_blank), client: @client
    end

    # Reaches the network for nothing: the lead is named, and moved once it is asked to be.
    # @param id [String] ID Housecall Pro files the lead under.
    # @return [Lead] the lead, able to move through the pipeline.
    def find(id) = Lead.new node: { id: id }, client: @client
  end
end
