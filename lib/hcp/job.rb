module Hcp
  # Work a Housecall Pro user accepted: what it is, who it is for, and what it comes to.
  class Job < Resource
    extend Queryable
    include Scheduled, Statused, Timestamped

    # What a list of jobs may be narrowed by, against the parameters Housecall Pro takes.
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

    # What Housecall Pro will put a list of jobs in order of.
    SORTS = %i[created_at updated_at invoice_number id description work_status]

    # What a job brings back beside itself where it is asked to.
    EXPANDS = %i[attachments appointments]

    # Where Housecall Pro keeps them, and what it calls a page of them.
    def self.path = 'jobs'
    def self.key = 'jobs'

    # @return [String, nil] the number the job invoices under.
    def invoice_number = @node['invoice_number']

    # @return [String, nil] what the work is, in the words whoever opened the job wrote.
    def description = @node['description']

    # @return [BigDecimal, nil] what the job comes to, before tax.
    def subtotal = money 'subtotal'

    # @return [BigDecimal, nil] what the job comes to.
    def total_amount = money 'total_amount'

    # @return [BigDecimal, nil] what is still owed on the job.
    def outstanding_balance = money 'outstanding_balance'

    # @return [String, nil] where the work came from.
    def lead_source = @node['lead_source']

    # @return [Array<String>] what the job is tagged with.
    def tags = Array(@node['tags'])

    # @return [String, nil] the ID of the estimate the job was won with.
    def original_estimate_id = @node['original_estimate_id']

    # @return [Time, nil] when the job was locked against further changes.
    def locked_at = time 'locked_at'

    # @return [Time, nil] when the customer canceled the job.
    def canceled_at = time 'canceled_at'

    # @return [Customer, nil] whose job it is.
    def customer = record Customer, 'customer'

    # @return [Address, nil] where the work happens.
    def address = record Address, 'address'

    # @return [Array<Note>] what the pros wrote on the job.
    def notes = records Note, 'notes'

    # @return [Array<Employee>] the pros the job is assigned to.
    def assigned_employees = records Employee, 'assigned_employees'

    # @return [Relation] the visits the job is booked for.
    def appointments = nested Job::Appointment, 'appointments'

    # @return [Relation] what the job is billed as.
    def line_items = nested LineItem, 'line_items'

    # @return [Relation] the invoices raised for the job.
    def invoices = nested Job::Invoice, 'invoices'
  end
end
