require 'test_helper'

class ChainableTestCase < Minitest::Test
  def test_narrows_a_list_by_the_conditions_housecall_takes
    stub_page 'jobs', 'jobs', [ { 'id' => 'job_1' } ],
      query: { page: 1, page_size: 200, customer_id: 'cus_1' }

    assert_equal %w[job_1], Hcp::Job.where(customer_id: 'cus_1').map(&:id)
  end

  def test_carries_a_condition_housecall_takes_more_than_one_of_as_a_list
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      work_status: %w[in_progress], }

    assert_empty Hcp::Job.where(work_status: :in_progress).to_a
  end

  def test_orders_a_list_by_the_field_and_the_direction_housecall_takes
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      sort_by: 'updated_at', sort_direction: 'desc', }

    assert_empty Hcp::Job.order(updated_at: :desc).to_a
  end

  def test_asks_housecall_to_bring_back_what_it_leaves_out_unasked
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      expand: %w[appointments], }

    assert_empty Hcp::Job.includes(:appointments).to_a
  end

  # Housecall Pro ignores a condition it does not take, answering the whole account rather
  # than a page of it, so the gem has to be the one that refuses.
  def test_refuses_a_condition_housecall_would_silently_ignore
    error = assert_raises(Hcp::Error) { Hcp::Job.all.where(bogus: 1) }

    assert_equal 'bogus is not one of: scheduled_at, ends_at, customer_id, employee_ids, ' \
      'work_status, location_ids', error.message
  end

  # The location is a header rather than a condition: sent as one it would be ignored, and
  # the default location's records would come back as though they were the right ones.
  def test_refuses_the_location_as_a_condition_on_a_list_already_opened
    error = assert_raises(Hcp::Error) { Hcp::Job.all.where(company_id: 'x') }

    assert_includes error.message, 'company_id is not one of'
  end

  def test_refuses_an_order_housecall_would_answer_with_a_bare_400
    error = assert_raises(Hcp::Error) { Hcp::Job.order(bogus: :desc) }

    assert_equal 'bogus is not one of: created_at, updated_at, invoice_number, id, ' \
      'description, work_status', error.message
  end

  def test_refuses_to_bring_back_what_housecall_cannot
    error = assert_raises(Hcp::Error) { Hcp::Job.includes(:bogus) }

    assert_equal 'bogus is not one of: attachments, appointments', error.message
  end
end
