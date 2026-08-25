require 'test_helper'

class RelationTestCase < Minitest::Test
  def test_walks_every_page_until_housecall_says_there_are_no_more
    stub_page 'jobs', 'jobs', [ { 'id' => 'job_1' } ], total_pages: 2
    stub_page 'jobs', 'jobs', [ { 'id' => 'job_2' } ],
      query: { page: 2, page_size: 200 }, total_pages: 2

    assert_equal %w[job_1 job_2], Hcp::Job.all.map(&:id)
  end

  # A walk cut short asks for what it will keep: a page of two hundred to hand back one is
  # two hundred records read, however few of them are yielded.
  def test_asks_for_no_more_records_than_the_limit
    stub_page 'jobs', 'jobs', [ { 'id' => 'job_1' } ],
      query: { page: 1, page_size: 1 }, total_pages: 9

    assert_equal %w[job_1], Hcp::Job.limit(1).map(&:id)
  end

  def test_reads_a_collection_housecall_does_not_page_as_the_whole_of_it
    stub_read 'jobs/job_1/appointments', { 'appointments' => [ { 'id' => 'appt_1' } ] },
      query: { page: 1, page_size: 200 }

    assert_equal %w[appt_1], Hcp::Job.new(node: { 'id' => 'job_1' }).appointments.map(&:id)
  end

  def test_counts_by_asking_for_one_record_rather_than_by_walking_the_list
    stub_read 'jobs', { 'total_items' => 3272, 'jobs' => [] }, query: { page_size: 1 }

    assert_equal 3272, Hcp::Job.all.count
  end

  def test_counts_no_further_than_the_limit
    stub_read 'jobs', { 'total_items' => 3272, 'jobs' => [] }, query: { page_size: 1 }

    assert_equal 5, Hcp::Job.limit(5).count
  end

  def test_reads_one_record_by_the_id_housecall_files_it_under
    stub_read 'jobs/job_1', { 'id' => 'job_1', 'description' => 'Fascia repair' }

    assert_equal 'Fascia repair', Hcp::Job.find('job_1').description
  end

  def test_hands_back_an_enumerator_where_it_is_walked_without_a_block
    assert_kind_of Enumerator, Hcp::Job.all.each
  end

  def test_hands_back_the_list_where_it_is_walked_with_one
    stub_page 'jobs', 'jobs', []

    assert_kind_of Hcp::Relation, Hcp::Job.all.each { }
  end
end
