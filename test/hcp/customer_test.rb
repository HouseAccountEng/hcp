require 'test_helper'

class CustomerTestCase < Minitest::Test
  def setup
    @customer = Hcp::Customer.new node: fixture('customers')['customers'].first
  end

  def test_reads_who_the_customer_is_and_how_to_reach_them
    assert_equal 'cus_c3fd9f15d014442aa3165fccf68ae95c', @customer.id
    assert_equal 'Ada Example', @customer.name
    assert_equal 'Ada', @customer.first_name
    assert_equal 'Example', @customer.last_name
    assert_equal 'ada@example.com', @customer.email
    assert_equal '5550000001', @customer.phone
    assert_nil @customer.company
    assert_equal :homeowner, @customer.kind
    assert_predicate @customer, :notifications_enabled?
    assert_nil @customer.lead_source
    assert_empty @customer.tags
    assert_equal Time.utc(2026, 6, 21, 14, 1, 7), @customer.created_at
  end

  # Housecall Pro holds three numbers, and a caller wants whichever one there is.
  def test_falls_back_to_the_next_number_housecall_holds
    node = { 'home_number' => '5550000002' }

    assert_equal '5550000002', Hcp::Customer.new(node: node).phone
  end

  def test_searches_by_the_one_free_text_condition_housecall_takes
    stub_page 'customers', 'customers', [ { 'id' => 'cus_1' } ],
      query: { page: 1, page_size: 200, q: 'Ada' }

    assert_equal %w[cus_1], Hcp::Customer.where(q: 'Ada').map(&:id)
  end

  def test_reads_every_address_the_customer_is_billed_or_served_at
    stub_read 'customers/cus_1/addresses', fixture('addresses'),
      query: { page: 1, page_size: 200 }

    address = Hcp::Customer.new(node: { 'id' => 'cus_1' }).addresses.first

    assert_equal :billing, address.type
    assert_equal '1 Example Street', address.street
    assert_nil address.street_line_2
    assert_equal 'Springfield', address.city
    assert_equal 'CA', address.state
    assert_equal '90210', address.zip
    assert_equal 'US', address.country
    assert_in_delta 34.0, address.latitude
    assert_in_delta(-118.0, address.longitude)
  end
end
