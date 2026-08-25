require 'test_helper'

class EventTestCase < Minitest::Test
  # Housecall Pro names the event and hangs the record it happened to beside it.
  def test_reads_what_happened_and_which_job_it_happened_to
    event = Hcp::Event.new event: 'job.scheduled', job: { id: 'job_1',
      customer: { id: 'cus_1' }, original_estimate_id: 'csr_1',
      schedule: { scheduled_start: '2026-06-26T10:45:00Z' },
      work_timestamps: { completed_at: '2026-06-26T12:45:00Z' }, }

    assert_equal :job_scheduled, event.type
    assert_equal 'job_1', event.job_id
    assert_equal 'cus_1', event.customer_id
    assert_equal 'csr_1', event.estimate_id
    assert_equal Time.utc(2026, 6, 26, 10, 45), event.scheduled_at
    assert_equal Time.utc(2026, 6, 26, 12, 45), event.completed_at
  end

  def test_reads_what_a_lead_was_last_turned_into
    event = Hcp::Event.new event: 'lead.converted', lead: { id: 'lea_1',
      customer: { id: 'cus_1' }, conversions: [ { 'type' => 'Estimate', 'id' => 'csr_1' } ], }

    assert_equal :lead_converted, event.type
    assert_equal 'lea_1', event.lead_id
    assert_equal :estimate, event.conversion_type
    assert_equal 'csr_1', event.conversion_id
  end

  # Housecall Pro counts an invoice in cents, and a caller reads it in dollars.
  def test_reads_what_an_invoice_came_to
    event = Hcp::Event.new event: 'invoice.sent',
      invoice: { id: 'inv_1', job_id: 'job_1', amount: '33000' }

    assert_equal 'inv_1', event.invoice_id
    assert_equal 'job_1', event.invoice_job_id
    assert_equal 330, event.invoice_amount
  end

  def test_reads_an_estimate_sent_on_its_own_rather_than_through_a_job
    event = Hcp::Event.new event: 'estimate.sent', estimate: { id: 'csr_1' }

    assert_equal 'csr_1', event.estimate_id
  end

  def test_names_no_event_where_housecall_sent_none
    assert_empty Hcp::Event.new.type.to_s
  end
end
