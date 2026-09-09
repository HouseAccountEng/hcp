require 'test_helper'

class QuoteTestCase < Minitest::Test
  # A job names the estimate option it was created from, and Housecall Pro reads estimates by
  # their own IDs, so the option is found among the customer's estimates, read once.
  def setup
    @quote = Hcp::Quote.new node: { id: 'est_1', customer: { id: 'cus_2' } },
      client: Hcp::Client.new(key: 'test-key')
  end

  def test_prices_the_quote_by_the_option_the_job_was_created_from_read_once
    stub_estimates [ { id: 'csr_1', options: [ { id: 'est_0', total_amount: 10_000 } ] },
                     { id: 'csr_2', options: [ { id: 'est_1', total_amount: 24_000 } ] }, ]

    assert_equal 240, @quote.amount
    assert_instance_of BigDecimal, @quote.amount
    assert_requested :get, "#{HousecallStubs::HOST}/estimates", times: 1,
      query: { customer_id: 'cus_2', page_size: 200 }
  end

  def test_prices_no_quote_where_no_estimate_of_the_customer_holds_the_option
    stub_estimates [ { id: 'csr_1', options: [ { id: 'est_0', total_amount: 10_000 } ] } ]

    assert_nil @quote.amount
  end

private

  def stub_estimates(estimates)
    stub_read 'estimates', { estimates: estimates }, query: { customer_id: 'cus_2', page_size: 200 }
  end
end
