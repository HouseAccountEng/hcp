module Hcp
  # Work a Housecall Pro user offered to do, priced as one option or several.
  class Estimate < Resource
    extend Queryable
    include Scheduled, Statused, Timestamped

    # What a list of estimates may be narrowed by, against the parameters Housecall Pro takes.
    FILTERS = {
      scheduled_at: %i[scheduled_start_min scheduled_start_max],
      ends_at: %i[scheduled_end_min scheduled_end_max],
      customer_id: %i[customer_id],
      employee_ids: %i[employee_ids],
      work_status: %i[work_status],
      location_ids: %i[location_ids],
    }

    # The conditions Housecall Pro takes more than one of, and refuses one of.
    MANY = %i[employee_ids work_status location_ids]

    # What Housecall Pro will put a list of estimates in order of.
    SORTS = %i[created_at updated_at id]

    # What an estimate brings back beside itself where it is asked to.
    EXPANDS = %i[attachments]

    # Where Housecall Pro keeps them, and what it calls a page of them.
    def self.path = 'estimates'
    def self.key = 'estimates'

    # The number the estimate is filed under, and where the work came from.
    attributes :estimate_number, :lead_source

    # @return [Customer, nil] whose estimate it is.
    def customer = record Customer, 'customer'

    # @return [Address, nil] where the work would happen.
    def address = record Address, 'address'

    # @return [Array<Employee>] the pros the estimate is assigned to.
    def assigned_employees = records Employee, 'assigned_employees'

    # @return [Array<Estimate::Option>] what the customer was offered, priced.
    def options = records Estimate::Option, 'options'
  end
end
