require 'test_helper'

class AnswerTestCase < Minitest::Test
  # Housecall Pro writes a refusal three ways, and a caller should never be handed raw JSON
  # to read the reason out of.
  def test_reads_the_reason_out_of_a_refusal_that_names_it_under_an_error
    stub_read 'company', { error: { message: 'Size must be less than or equal to 200' } },
      status: 400

    error = assert_raises(Hcp::Error) { account.business }

    assert_equal 'Size must be less than or equal to 200', error.message
  end

  def test_reads_the_reason_out_of_a_refusal_whose_error_is_the_reason
    stub_read 'company', { error: 'Company not found' }, status: 404

    error = assert_raises(Hcp::Error) { account.business }

    assert_equal 'Company not found', error.message
  end

  def test_reads_the_reason_out_of_a_refusal_that_carries_it_on_its_own
    stub_read 'company', { message: 'scheduled_start_min filter must be valid' }, status: 400

    error = assert_raises(Hcp::Error) { account.business }

    assert_equal 'scheduled_start_min filter must be valid', error.message
  end

  def test_names_a_refusal_for_rate_so_a_caller_can_come_back
    stub_read 'company', { error: 'Too many requests' }, status: 429

    error = assert_raises(Hcp::Throttled) { account.business }

    assert_equal 'Too many requests', error.message
  end
end
