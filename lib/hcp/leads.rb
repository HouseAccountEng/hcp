module Hcp
  # The leads of one location: who asked a Housecall Pro user for work, before there is a job.
  class Leads < Company::Leads
    # @param client [Client] how to reach Housecall Pro as the location.
    def initialize(client:)
      @client = client
    end

    # Opens a lead, and a customer with it, on Housecall Pro. A lead has no title of its own, so
    # the description heads the note and the notes follow it.
    # @return [Lead] lead as Housecall Pro filed it, with its customer's ID beside it.
    def create(name:, surname:, phone:, email:, address:, description:, notes:, source:)
      customer = { first_name: name, last_name: surname, email: email, mobile_number: phone,
                   lead_source: source, }
      body = { customer: customer.compact_blank, address: address, lead_source: source,
               note: [ description, notes ].compact_blank.join("\n"), }
      Lead.new node: @client.post('leads', body.compact_blank), client: @client
    end

    # Reaches the network for nothing: the lead is named, and moved once it is asked to be.
    # @param id [String] ID Housecall Pro files the lead under.
    # @return [Lead] the lead, able to move through the pipeline.
    def find(id) = Lead.new node: { id: id }, client: @client
  end
end
