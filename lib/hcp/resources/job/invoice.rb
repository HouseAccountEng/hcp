module Hcp
  # A bill raised for a job.
  class Job::Invoice < Resource
    # What Housecall Pro calls a list of them.
    def self.key = 'invoices'

    attribute :invoice_number

    # @return [String, nil] where Housecall Pro files the invoice in its own workflow.
    attribute :status

    amount :amount
    amount :due_amount

    # @return [Time, nil] when the invoice was sent.
    timestamp :sent_at

    # @return [Time, nil] when the invoice was paid.
    timestamp :paid_at
  end
end
