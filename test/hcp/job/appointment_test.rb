require 'test_helper'

class AppointmentTestCase < Minitest::Test
  # Housecall Pro nests the visits under the schedule where a list was asked to bring them.
  def test_reads_the_visits_a_list_was_asked_to_bring_back_with_each_job
    stub_page 'jobs', 'jobs', [ fixture('jobs')['jobs'].first ],
      query: { page: 1, page_size: 200, expand: %w[appointments] }

    visits = Hcp::Job.includes(:appointments).first.schedule.appointments

    assert_equal %w[appt_02aad0c5d573454cae36e5fa24c839bc], visits.map(&:id)
  end

  def test_reads_when_a_visit_is_booked_for_and_who_is_sent_on_it
    stub_read 'jobs/job_1/appointments', fixture('appointments'),
      query: { page: 1, page_size: 200 }

    visit = Hcp::Job.new(node: { 'id' => 'job_1' }).appointments.first

    assert_equal 'appt_02aad0c5d573454cae36e5fa24c839bc', visit.id
    assert_equal Time.utc(2026, 6, 26, 10, 45), visit.starts_at
    assert_equal Time.utc(2026, 6, 26, 12, 45), visit.ends_at
    assert_equal 30, visit.arrival_window
    refute_predicate visit, :anytime?
    assert_empty visit.dispatched_employee_ids
  end
end
