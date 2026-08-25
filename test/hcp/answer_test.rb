require 'test_helper'

class AnswerTestCase < Minitest::Test
  # Housecall Pro writes a refusal three ways, and a caller should never be handed raw JSON
  # to read the reason out of.
  def test_reads_the_reason_out_of_a_refusal_that_names_it_under_an_error
    stub_read 'jobs/job_1', { error: { message: 'Size must be less than or equal to 200' } },
      status: 400

    error = assert_raises(Hcp::Error) { Hcp::Job.find 'job_1' }

    assert_equal 'Size must be less than or equal to 200', error.message
  end

  def test_reads_the_reason_out_of_a_refusal_whose_error_is_the_reason
    stub_read 'jobs/job_1', { error: 'Job not found' }, status: 404

    error = assert_raises(Hcp::NotFound) { Hcp::Job.find 'job_1' }

    assert_equal 'Job not found', error.message
  end

  def test_reads_the_reason_out_of_a_refusal_that_carries_it_on_its_own
    stub_read 'jobs/job_1', { message: 'scheduled_start_min filter must be valid' }, status: 400

    error = assert_raises(Hcp::Error) { Hcp::Job.find 'job_1' }

    assert_equal 'scheduled_start_min filter must be valid', error.message
  end

  # Nothing here sleeps: the caller is told when the limit lifts and decides for itself.
  def test_says_when_a_refusal_for_rate_will_lift
    stub_read 'jobs/job_1', { error: 'Too many requests' }, status: 429,
      headers: { 'RateLimit-Reset' => '1787000000' }

    error = assert_raises(Hcp::TooManyRequests) { Hcp::Job.find 'job_1' }

    assert_equal Time.at(1787000000), error.reset_at
  end

  def test_says_nothing_about_when_a_refusal_for_rate_will_lift_where_housecall_does_not
    stub_read 'jobs/job_1', { error: 'Too many requests' }, status: 429

    assert_nil assert_raises(Hcp::TooManyRequests) { Hcp::Job.find 'job_1' }.reset_at
  end
end
