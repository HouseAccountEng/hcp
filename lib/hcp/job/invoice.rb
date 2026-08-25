module Hcp
  # A bill raised for a job.
  class Job::Invoice < Resource
    # What Housecall Pro calls a list of them.
    def self.key = 'invoices'

    # The number the invoice is filed under, and where Housecall Pro files it in its workflow.
    attributes :invoice_number, :status

    # What the invoice comes to, and what is still owed on it.
    amounts :amount, :due_amount

    # When the invoice was sent, and when it was paid.
    timestamps :sent_at, :paid_at
  end
end
