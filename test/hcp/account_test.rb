require 'test_helper'

class AccountTestCase < Minitest::Test
  def test_reads_with_the_key_it_was_given
    read = stub_request(:get, "#{HousecallStubs::HOST}/company").
      with(headers: { 'Authorization' => 'Token test-key' }).
      to_return body: fixture('company').to_json

    account.business

    assert_requested read
  end

  def test_acts_as_the_location_it_was_given
    stub_request(:get, "#{HousecallStubs::HOST}/company").
      with(headers: { 'X-Company-Id' => '6b0d549b-6f03-475a-9600-a35a099950d8' }).
      to_return body: fixture('company_location').to_json

    business = account(company_id: '6b0d549b-6f03-475a-9600-a35a099950d8').business

    assert_equal 'Example Handyman - Ogdenville', business.name
  end

  # The account a key belongs to refuses the header outright, so it is not sent blank either.
  def test_names_no_location_where_it_acts_as_the_account_itself
    read = stub_request(:get, "#{HousecallStubs::HOST}/company").
      with { |request| !request.headers.key? 'X-Company-Id' }.
      to_return body: fixture('company').to_json

    account.business

    assert_requested read
  end

  def test_refuses_what_a_key_does_not_open
    assert_raises(NotImplementedError) { account.quotes }
  end
end
