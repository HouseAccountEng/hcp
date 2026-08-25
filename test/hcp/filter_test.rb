require 'test_helper'

class FilterTestCase < Minitest::Test
  # The example the README leads with: everything up to a moment, and no lower bound at all.
  def test_sends_only_the_upper_bound_where_the_range_has_no_beginning
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      scheduled_start_max: '2026-08-23T00:00:00Z', }

    assert_empty Hcp::Job.where(scheduled_at: ..Time.utc(2026, 8, 23)).to_a
  end

  def test_sends_only_the_lower_bound_where_the_range_has_no_end
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      scheduled_start_min: '2026-08-23T00:00:00Z', }

    assert_empty Hcp::Job.where(scheduled_at: Time.utc(2026, 8, 23)..).to_a
  end

  def test_sends_both_bounds_where_the_range_has_two
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      scheduled_start_min: '2026-08-01T00:00:00Z', scheduled_start_max: '2026-08-23T00:00:00Z', }

    assert_empty Hcp::Job.where(scheduled_at: Time.utc(2026, 8)..Time.utc(2026, 8, 23)).to_a
  end

  def test_reads_a_moment_in_utc_however_the_caller_wrote_it
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      scheduled_start_min: '2026-08-23T08:00:00Z', }

    assert_empty Hcp::Job.where(scheduled_at: Time.new(2026, 8, 23, 1, 0, 0, '-07:00')..).to_a
  end

  def test_reads_a_date_as_the_day_housecall_names_it
    stub_page 'jobs', 'jobs', [], query: { page: 1, page_size: 200,
      scheduled_start_min: '2026-08-23', }

    assert_empty Hcp::Job.where(scheduled_at: Date.new(2026, 8, 23)..).to_a
  end

  # Housecall Pro reads both ends inclusively, so an excluded end would come back anyway.
  def test_refuses_a_range_that_excludes_its_end
    error = assert_raises(Hcp::Error) { Hcp::Job.where(scheduled_at: Time.now...Time.now).to_a }

    assert_equal 'scheduled_start_max cannot exclude its end', error.message
  end

  def test_refuses_a_range_for_a_condition_housecall_takes_one_value_for
    error = assert_raises(Hcp::Error) { Hcp::Job.where(customer_id: 'a'..'b').to_a }

    assert_equal 'customer_id takes one value, not a range', error.message
  end
end
