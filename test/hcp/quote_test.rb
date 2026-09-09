require 'test_helper'

class QuoteTestCase < Minitest::Test
  # Housecall Pro names the estimate beside the job and prices it by options, so the quote
  # reads the estimate once and answers the option the customer approved.
  def setup
    @quote = Hcp::Quote.new node: { id: 'est_1' }, client: Hcp::Client.new(key: 'test-key')
  end

  def test_prices_the_quote_by_the_option_the_customer_approved_read_once
    stub_estimate [ { approval_status: nil, total_amount: 10_000 },
                    { approval_status: 'approved', total_amount: 24_000 }, ]

    assert_equal 240, @quote.amount
    assert_instance_of BigDecimal, @quote.amount
    assert_requested :get, "#{HousecallStubs::HOST}/estimates/est_1", times: 1
  end

  def test_prices_no_quote_where_the_customer_approved_no_option
    stub_estimate [ { approval_status: 'declined', total_amount: 10_000 } ]

    assert_nil @quote.amount
  end

private

  def stub_estimate(options) = stub_read('estimates/est_1', { options: options })
end
