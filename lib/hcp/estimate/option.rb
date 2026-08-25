module Hcp
  # One of the things a customer was offered on an estimate, priced on its own.
  class Estimate::Option < Resource
    include Timestamped

    # @return [String, nil] what the option is called.
    def name = @node['name']

    # @return [String, nil] the number the option is filed under.
    def option_number = @node['option_number']

    # @return [BigDecimal, nil] what the option comes to.
    def total_amount = money 'total_amount'

    # @return [String, nil] whether the customer has answered, and how.
    def approval_status = @node['approval_status']

    # @return [String, nil] where Housecall Pro files the option in its own workflow.
    def status = @node['status']

    # @return [String, nil] what the pro said when they sent it.
    def message_from_pro = @node['message_from_pro']

    # @return [Array<String>] what the option is tagged with.
    def tags = Array(@node['tags'])

    # @return [Array<Note>] what the pros wrote on the option.
    def notes = records Note, 'notes'
  end
end
