require 'test_helper'

class PipelineTestCase < Minitest::Test
  # Housecall Pro moves a lead by status ID, and names them only by their words, so the
  # status has to be looked up before it can be set.
  def setup
    @pipeline = Hcp::Lead::Pipeline.new id: 'lea_1', key: 'lead-key', company_id: 'loc_1'
    @statuses = 'https://api.housecallpro.com/pipeline/statuses'
  end

  def test_moves_a_lead_to_the_status_that_goes_by_that_name
    stub_request(:get, @statuses).with(query: { resource_type: 'lead' }).
      to_return body: { statuses: [ { 'id' => 'sta_1', 'name' => 'Won' } ] }.to_json
    moved = stub_request(:put, @statuses).
      with body: { resource_type: 'lead', resource_id: 'lea_1', status_id: 'sta_1' }

    @pipeline.update status_name: 'Won'

    assert_requested moved
  end

  def test_raises_where_the_account_has_no_status_going_by_that_name
    stub_request(:get, @statuses).with(query: { resource_type: 'lead' }).
      to_return body: { statuses: [] }.to_json

    error = assert_raises(Hcp::Error) { @pipeline.update status_name: 'Won' }

    assert_equal 'Status Won not found for lead lea_1', error.message
  end

  def test_raises_where_housecall_refuses_the_move
    stub_request(:get, @statuses).with(query: { resource_type: 'lead' }).
      to_return body: { statuses: [ { 'id' => 'sta_1', 'name' => 'Won' } ] }.to_json
    stub_request(:put, @statuses).to_return status: 422, body: 'Status not allowed'

    error = assert_raises(Hcp::Error) { @pipeline.update status_name: 'Won' }

    assert_equal 'Status not allowed', error.message
  end

  def test_raises_where_housecall_cannot_be_reached_at_all
    stub_request(:get, @statuses).with(query: { resource_type: 'lead' }).
      to_raise Errno::ECONNREFUSED

    assert_raises(Hcp::Error) { @pipeline.update status_name: 'Won' }
  end
end
