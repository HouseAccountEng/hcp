require 'test_helper'

class BookingWindowTestCase < Minitest::Test
  # Housecall Pro answers these whole, so there is no page to ask for.
  def test_reads_every_window_in_the_range
    stub_read 'company/schedule_availability/booking_windows', fixture('booking_windows')

    windows = Hcp::BookingWindow.all

    assert_equal 2, windows.size
    assert_equal Time.utc(2026, 8, 27, 15), windows.first.starts_at
    assert_equal Time.utc(2026, 8, 27, 17), windows.first.ends_at
    assert windows.first.available?
    refute windows.last.available?
  end

  # Housecall Pro takes the moment to look from without a zone on it.
  def test_asks_for_a_range_of_its_own
    stub_read 'company/schedule_availability/booking_windows', fixture('booking_windows'),
      query: { start_date: '2026-08-27T09:00:00', show_for_days: 3, service_duration: 90,
        service_id: 'svc_1', price_form_id: 'pf_1', employee_ids: %w[emp_1 emp_2], }

    windows = Hcp::BookingWindow.all starts_at: Time.utc(2026, 8, 27, 9), days: 3, minutes: 90,
      service_id: 'svc_1', price_form_id: 'pf_1', employee_ids: %w[emp_1 emp_2]

    assert_equal 2, windows.size
  end

  # A second location reads its own schedule rather than the first one's.
  def test_reads_a_location_of_its_own
    stub_request(:get, "#{HousecallStubs::HOST}/company/schedule_availability/booking_windows").
      with(headers: { 'X-Company-Id' => 'com_1' }).
      to_return body: fixture('booking_windows').to_json

    assert_equal 2, Hcp::BookingWindow.all(company_id: 'com_1').size
  end
end
