module Hcp
  # A bill raised for a job.
  class Job::Invoice < Resource
    # What Housecall Pro calls a list of them.
    def self.key = 'invoices'

    # @return [String, nil] the number the invoice is filed under.
    def invoice_number = @node['invoice_number']

    # @return [String, nil] where Housecall Pro files the invoice in its own workflow.
    def status = @node['status']

    # @return [BigDecimal, nil] what the invoice comes to.
    def amount = money 'amount'

    # @return [BigDecimal, nil] what is still owed on it.
    def due_amount = money 'due_amount'

    # @return [Time, nil] when the invoice was sent.
    def sent_at = time 'sent_at'

    # @return [Time, nil] when the invoice was paid.
    def paid_at = time 'paid_at'
  end
end
