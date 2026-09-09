require 'test_helper'

class LeadsTestCase < Minitest::Test
  def setup
    @leads = "#{HousecallStubs::HOST}/leads"
  end

  # A blank address and a blank field are left out rather than sent as null.
  def test_opens_a_lead_and_hands_it_back_with_what_housecall_filed_it_under
    stub_request(:post, @leads).
      with(body: { customer: { first_name: 'Ada', email: 'ada@example.com',
        mobile_number: '5550000001', lead_source: 'A Sign', }, lead_source: 'A Sign',
        note: 'Wants a quote', }, headers: { 'Authorization' => 'Token test-key',
        'X-Company-Id' => 'loc_1', }).
      to_return body: { id: 'lea_1', customer: { id: 'cus_1' } }.to_json

    lead = account(company_id: 'loc_1').leads.create name: 'Ada', email: 'ada@example.com',
      phone: '5550000001', address: nil, source: 'A Sign', note: 'Wants a quote'

    assert_equal 'lea_1', lead.id
    assert_equal 'cus_1', lead.customer_id
  end

  def test_raises_where_housecall_would_not_open_one
    stub_request(:post, @leads).
      to_return status: 422, body: { error: 'Lead source not found' }.to_json

    error = assert_raises(Hcp::Error) { create_lead }

    assert_equal 'Lead source not found', error.message
  end

  def test_raises_where_housecall_cannot_be_reached_at_all
    stub_request(:post, @leads).to_raise Errno::ECONNREFUSED

    assert_raises(Hcp::Error) { create_lead }
  end

private

  def create_lead
    account.leads.create name: 'Ada', email: nil, phone: nil, address: nil, source: nil, note: nil
  end
end
