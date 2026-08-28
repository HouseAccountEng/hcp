require 'test_helper'

class KeyTestCase < Minitest::Test
  def teardown = Hcp.key = 'test-key'

  def test_reads_every_record_with_the_key_it_was_given
    stub = stub_page('jobs', 'jobs', []).with headers: { 'Authorization' => 'Token test-key' }
    Hcp::Job.all.to_a

    assert_requested stub
  end

  def test_falls_back_to_the_key_the_environment_carries
    Hcp.key = nil
    ENV['HCP_KEY'] = 'from-env'

    assert_equal 'from-env', Hcp.key
  ensure
    ENV.delete 'HCP_KEY'
  end

  # The key of the block is the thread's alone, and the one set before it comes back after.
  def test_reads_as_the_key_of_the_block_and_then_as_before
    stub = stub_page('jobs', 'jobs', []).with headers: { 'Authorization' => 'Token block-key' }

    Hcp.with_key('block-key') { Hcp::Job.all.to_a }

    assert_requested stub
    assert_equal 'test-key', Hcp.key
  end

  def test_two_threads_hold_two_keys_without_seeing_each_other
    keys = %w[key-one key-two].map do |key|
      Thread.new { Hcp.with_key(key) { sleep 0.01; Hcp.key } }
    end

    assert_equal %w[key-one key-two], keys.map(&:value)
  end

  def test_the_block_is_handed_the_account_the_key_opens
    stub_request(:get, "#{HousecallStubs::HOST}/company").
      with(headers: { 'Authorization' => 'Token block-key', 'X-Company-Id' => 'loc_1' }).
      to_return body: fixture('company_location').to_json

    name = Hcp.with_key('block-key', company_id: 'loc_1') { |access| access.account.name }

    assert_equal 'Example Handyman - Ogdenville', name
  end

  def test_reads_a_location_of_its_own_where_the_account_has_several
    stub = stub_read('jobs/job_1', { 'id' => 'job_1' }).
      with headers: { 'X-Company-Id' => 'loc_1' }
    Hcp::Job.find 'job_1', company_id: 'loc_1'

    assert_requested stub
  end
end
