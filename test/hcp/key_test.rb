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

  def test_reads_a_location_of_its_own_where_the_account_has_several
    stub = stub_read('jobs/job_1', { 'id' => 'job_1' }).
      with headers: { 'X-Company-Id' => 'loc_1' }
    Hcp::Job.find 'job_1', company_id: 'loc_1'

    assert_requested stub
  end
end
