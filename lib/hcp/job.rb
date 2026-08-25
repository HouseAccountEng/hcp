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

    # What the job is, where it came from, and the estimate it was won with.
    attributes :invoice_number, :description, :lead_source, :original_estimate_id

    # What the job comes to, before tax and after it, and what is still owed.
    amounts :subtotal, :total_amount, :outstanding_balance

    # When the job was locked against further changes, and when the customer canceled it.
    timestamps :locked_at, :canceled_at

    # @return [Array<String>] what the job is tagged with.
    def tags = Array(@node['tags'])

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
