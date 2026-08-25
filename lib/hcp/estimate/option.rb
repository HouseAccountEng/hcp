module Hcp
  # One of the things a customer was offered on an estimate, priced on its own.
  class Estimate::Option < Resource
    include Timestamped

    # What the option is called, whether the customer has answered, and where it stands.
    attributes :name, :option_number, :approval_status, :status, :message_from_pro

    # What the option comes to.
    amount :total_amount

    # @return [Array<String>] what the option is tagged with.
    def tags = Array(@node['tags'])

    # @return [Array<Note>] what the pros wrote on the option.
    def notes = records Note, 'notes'
  end
end
