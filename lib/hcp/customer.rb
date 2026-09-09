module Hcp
  # Whoever the work is for.
  class Customer < Company::Customer
    # The node keys Housecall Pro spells otherwise than the vocabulary.
    def self.keys = { name: :first_name, surname: :last_name }

    # The numbers Housecall Pro holds for a customer, the one they are reached on first.
    NUMBERS = %i[mobile_number home_number work_number]

    # @return [String, nil] first name, or the business's name where a person has none.
    def name = super.presence || attribute(:company).presence

    # @return [String, nil] ten digits they are reached on, nil where none can be dialed.
    def phone = NUMBERS.lazy.filter_map { |number| Company::Phone.from @node[number] }.first
  end
end
