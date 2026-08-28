require 'test_helper'

class CompanyTestCase < Minitest::Test
  # Housecall Pro answers the account whole, rather than wrapped in a page or under a name.
  def test_reads_the_account_the_key_belongs_to
    stub_read 'company', fixture('company')

    company = Hcp::Company.current

    assert_equal 'Example Handyman Group HQ', company.name
    assert_equal '(555) 555-0100', company.phone
    assert_equal 'hq@example.com', company.support_email
    assert_equal 'https://example.com/logos/hq.jpeg', company.logo_url
    assert_equal 'https://example.com', company.website
    assert_equal 'America/Los_Angeles', company.time_zone
    assert_equal 0, company.arrival_window
    assert_equal 'Springfield', company.address.city
    assert_empty company.zip_codes
  end

  # The company stamps its coordinates as strings where a customer's address stamps them as numbers.
  def test_reads_the_coordinates_whichever_way_they_are_stamped
    stub_read 'company', fixture('company')

    address = Hcp::Company.current.address

    assert_in_delta 34.0, address.latitude
    assert_in_delta(-118.0, address.longitude)
  end

  # A franchise arrives as a tree, and a location at the foot of it holds none of its own.
  def test_reads_the_locations_beneath_it
    stub_read 'company', fixture('company')

    region = Hcp::Company.current.locations.sole

    assert_equal 'Example Handyman Region', region.name
    assert_equal [ 'Example Handyman - Springfield', 'Example Handyman - Shelbyville' ],
      region.locations.map(&:name)
    assert_empty region.locations.first.locations
  end

  # A location reads its own settings rather than the ones the account was opened with.
  def test_reads_a_location_of_its_own
    stub_request(:get, "#{HousecallStubs::HOST}/company").
      with(headers: { 'X-Company-Id' => '6b0d549b-6f03-475a-9600-a35a099950d8' }).
      to_return body: fixture('company_location').to_json

    company = Hcp::Company.current company_id: '6b0d549b-6f03-475a-9600-a35a099950d8'

    assert_equal 'Example Handyman - Ogdenville', company.name
    assert_equal 'America/New_York', company.time_zone
    assert_equal 30, company.arrival_window
    assert_equal %w[28278 28213], company.zip_codes
  end
end
