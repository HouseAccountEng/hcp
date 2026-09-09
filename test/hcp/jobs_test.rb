require 'test_helper'

class JobsTestCase < Minitest::Test
  # Housecall Pro nests the schedule, the finish and the address, and counts in cents; a job
  # reads flat and in dollars, and one booked nowhere has no location rather than a blank one.
  def setup
    @jobs = "#{HousecallStubs::HOST}/jobs"
    stub_page 1, fixture('jobs')['jobs'], total_pages: 2
    stub_page 2, [ second_job ], total_pages: 2
  end

  def test_walks_every_job_booked_in_the_window_a_page_at_a_time
    unbooked, booked = account.jobs.past(2.weeks).to_a

    assert_equal 'job_77cbcb51acb1442fa9554131d7d1f543', unbooked.id
    assert_equal Time.utc(2026, 6, 26, 10, 45), unbooked.scheduled_at
    assert_equal Time.utc(2026, 6, 21, 13, 45, 35), unbooked.created_at
    assert_nil unbooked.completed_at
    assert_equal 330, unbooked.amount
    assert_instance_of BigDecimal, unbooked.amount
    assert_nil unbooked.notes
    assert_nil unbooked.quote
    assert_nil unbooked.location
    assert_equal 'job_2', booked.id
    assert_equal Time.utc(2026, 6, 27, 12), booked.completed_at
    assert_equal 'est_1', booked.quote.id
    assert_equal "- Gate code 1234\n- Dog in the yard", booked.notes
    assert_equal '1 Example Street', booked.location.street
    assert_equal '90210', booked.location.zip
    assert_in_delta 34.07, booked.location.latitude
  end

  def test_asks_for_the_jobs_booked_to_start_that_long_ago_at_most_and_before_now
    account.jobs.past(2.weeks).first

    assert_requested(:get, @jobs, query: hash_including(page: '1'), times: 1) do |request|
      min, max = request.uri.query_values.values_at('scheduled_start_min', 'scheduled_start_max')
      (Time.now - 2.weeks - Time.iso8601(min)).abs < 60 && (Time.now - Time.iso8601(max)).abs < 60
    end
  end

  def test_reads_whose_place_the_work_happens_at_by_whichever_name_and_number_they_have
    customer = account.jobs.past(2.weeks).to_a.last.location.customer

    assert_equal 'cus_2', customer.id
    assert_equal 'Acme Property Management', customer.name
    assert_nil customer.surname
    assert_equal 'acme@example.com', customer.email
    assert_equal '5552000002', customer.phone
  end

  # Housecall Pro files the lines under their own endpoint, so a job reads them once, on the
  # first ask, however many times it is asked.
  def test_reads_the_lines_off_their_own_endpoint_once
    stub_read 'jobs/job_77cbcb51acb1442fa9554131d7d1f543/line_items', fixture('line_items')

    job = account.jobs.past(2.weeks).first

    assert_equal 'Exterior trim - Fascia repair', job.lines.sole.name
    assert_equal 1, job.lines.sole.quantity
    assert_equal 330, job.lines.sole.amount
    assert_requested :get, "#{@jobs}/job_77cbcb51acb1442fa9554131d7d1f543/line_items", times: 1
  end

private

  def stub_page(page, jobs, total_pages:)
    stub_request(:get, @jobs).with(query: hash_including(page: page.to_s, page_size: '200')).
      to_return body: { page: page, total_pages: total_pages, jobs: jobs }.to_json
  end

  def second_job
    { id: 'job_2', description: 'Paint the fence', total_amount: 12_000,
      schedule: { scheduled_start: '2026-06-27T10:00:00Z' },
      work_timestamps: { completed_at: '2026-06-27T12:00:00Z' }, original_estimate_id: 'est_1',
      notes: [ { content: 'Gate code 1234' }, { content: 'Dog in the yard' } ],
      address: { id: 'adr_1', street: '1 Example Street', city: 'Beverly Hills', state: 'CA',
                 zip: '90210', latitude: 34.07, longitude: -118.4, },
      customer: { id: 'cus_2', first_name: nil, last_name: nil, company: 'Acme Property Management',
                  email: 'acme@example.com', mobile_number: nil, home_number: '(555) 200-0002', },
    }
  end
end
