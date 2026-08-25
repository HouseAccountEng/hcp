module Hcp
  # A pro on a Housecall Pro account.
  class Employee < Resource
    include Named, Timestamped

    # How to reach the pro, and what they may do on the account.
    attributes :email, :role
    attribute :phone, :mobile_number
  end
end
