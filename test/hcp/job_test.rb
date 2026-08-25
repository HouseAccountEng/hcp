require 'test_helper'

class JobTestCase < Minitest::Test
  def setup
    @job = Hcp::Job.new node: fixture('jobs')['jobs'].first
  end

  def test_reads_what_the_work_is_and_what_it_comes_to
    assert_equal 'job_77cbcb51acb1442fa9554131d7d1f543', @job.id
    assert_equal 'Exterior trim - Fascia repair', @job.description
    assert_equal '51575153', @job.invoice_number
    assert_equal 330, @job.total_amount
    assert_equal 330, @job.subtotal
    assert_equal 330, @job.outstanding_balance
    assert_nil @job.lead_source
    assert_empty @job.tags
    assert_nil @job.original_estimate_id
  end

  # Housecall Pro narrows a list by one set of words and answers with another.
  def test_reads_the_status_in_the_words_a_list_is_narrowed_by
    assert_equal :scheduled, @job.work_status
    refute_predicate @job, :rated?
    assert_equal :completed, Hcp::Job.new(node: { 'work_status' => 'complete rated' }).work_status
    assert_predicate Hcp::Job.new(node: { 'work_status' => 'complete rated' }), :rated?
  end

  def test_reads_when_the_work_is_booked_for_and_when_it_happened
    assert_equal Time.utc(2026, 6, 26, 10, 45), @job.schedule.starts_at
    assert_equal Time.utc(2026, 6, 26, 12, 45), @job.schedule.ends_at
    assert_equal 'America/New_York', @job.schedule.time_zone
    assert_equal 30, @job.schedule.arrival_window
    assert_equal Time.utc(2026, 6, 21, 13, 45, 35), @job.created_at
    assert_equal Time.utc(2026, 6, 21, 13, 45, 36), @job.updated_at
    assert_nil @job.started_at
    assert_nil @job.completed_at
    assert_nil @job.on_my_way_at
    assert_nil @job.locked_at
    assert_nil @job.canceled_at
  end

  def test_reads_who_the_work_is_for_and_where_it_happens
    assert_equal 'Ada', @job.customer.name
    assert_equal 'HouseAccount', @job.customer.lead_source
    assert_equal :service, @job.address.type
    assert_empty @job.notes
    assert_empty @job.assigned_employees
  end
end
