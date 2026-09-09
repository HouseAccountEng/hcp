require 'test_helper'

class LeadTestCase < Minitest::Test
  # Housecall Pro moves a lead by status ID, and names them only by their words, so the
  # status has to be looked up before it can be set.
  def setup
    @lead = account.leads.find 'lea_1'
    @statuses = "#{HousecallStubs::HOST}/pipeline/statuses"
  end

  def test_finds_a_lead_without_reaching_housecall
    assert_equal 'lea_1', @lead.id
  end

  # Housecall Pro answers the move with no body at all.
  def test_moves_a_lead_to_the_status_that_goes_by_that_name
    stub_read 'pipeline/statuses', { statuses: [ { id: 'sta_1', name: 'Won' } ] },
      query: { resource_type: 'lead' }
    moved = stub_request(:put, @statuses).
      with body: { resource_type: 'lead', resource_id: 'lea_1', status_id: 'sta_1' }

    @lead.update status_name: 'Won'

    assert_requested moved
  end

  def test_raises_where_the_account_has_no_status_going_by_that_name
    stub_read 'pipeline/statuses', { statuses: [] }, query: { resource_type: 'lead' }

    error = assert_raises(Hcp::Error) { @lead.update status_name: 'Won' }

    assert_equal 'Status Won not found for lead lea_1', error.message
  end

  def test_raises_where_housecall_refuses_the_move
    stub_read 'pipeline/statuses', { statuses: [ { id: 'sta_1', name: 'Won' } ] },
      query: { resource_type: 'lead' }
    stub_request(:put, @statuses).to_return status: 422, body: { error: 'Not allowed' }.to_json

    error = assert_raises(Hcp::Error) { @lead.update status_name: 'Won' }

    assert_equal 'Not allowed', error.message
  end
end
