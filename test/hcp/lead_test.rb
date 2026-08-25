require 'test_helper'

class LeadTestCase < Minitest::Test
  # A lead is written with a key handed in per call, as everything was before the key
  # became global.
  def setup
    @lead = Hcp::Lead.new key: 'lead-key', company_id: 'loc_1'
  end

  def test_opens_a_lead_and_keeps_what_housecall_filed_it_under
    stub_request(:post, 'https://api.housecallpro.com/leads').
      with(body: { customer: { first_name: 'Ada', email: 'ada@example.com',
        mobile_number: '5550000001', lead_source: 'A Sign', }, lead_source: 'A Sign',
        note: 'Wants a quote', }, headers: { 'Authorization' => 'Token lead-key',
        'X-Company-Id' => 'loc_1', }).
      to_return body: { id: 'lea_1', customer: { id: 'cus_1' } }.to_json

    @lead.create name: 'Ada', email: 'ada@example.com', phone: '5550000001',
      source: 'A Sign', note: 'Wants a quote'

    assert_equal 'lea_1', @lead.id
    assert_equal 'cus_1', @lead.customer_id
  end

  def test_raises_where_housecall_would_not_open_one
    stub_request(:post, 'https://api.housecallpro.com/leads').
      to_return status: 422, body: 'Lead source not found'

    error = assert_raises(Hcp::Error) { @lead.create name: 'Ada' }

    assert_equal 'Lead source not found', error.message
  end

  def test_raises_where_housecall_cannot_be_reached_at_all
    stub_request(:post, 'https://api.housecallpro.com/leads').to_raise Errno::ECONNREFUSED

    assert_raises(Hcp::Error) { @lead.create name: 'Ada' }
  end
end
