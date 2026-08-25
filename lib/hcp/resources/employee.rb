module Hcp
  # A pro on a Housecall Pro account.
  class Employee < Resource
    include Named, Timestamped

    attribute :email
    attribute :role

    # @return [String, nil] the number the pro is reached on.
    attribute :phone, :mobile_number
  end
end
