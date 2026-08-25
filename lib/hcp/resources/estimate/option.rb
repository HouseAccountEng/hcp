module Hcp
  # One of the things a customer was offered on an estimate, priced on its own.
  class Estimate::Option < Resource
    include Timestamped

    attribute :name
    attribute :option_number

    # @return [String, nil] whether the customer has answered, and how.
    attribute :approval_status

    # @return [String, nil] where Housecall Pro files the option in its own workflow.
    attribute :status

    # @return [String, nil] what the pro said when they sent it.
    attribute :message_from_pro

    amount :total_amount

    # @return [Array<String>] what the option is tagged with.
    def tags = Array(@node['tags'])

    # @return [Array<Note>] what the pros wrote on the option.
    def notes = records Note, 'notes'
  end
end
