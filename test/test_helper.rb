require 'simplecov'
SimpleCov.start { minimum_coverage 100 }

require 'minitest/autorun'
require 'webmock/minitest'

require_relative '../lib/hcp'

# Where Housecall Pro answers, and the canned replies every test builds on.
module HousecallStubs
  # Where every request goes.
  HOST = 'https://api.housecallpro.com'

  # @return [Hash] one of the recorded answers under test/fixtures.
  def fixture(name) = JSON File.read("test/fixtures/#{name}.json")

  # @return [Hcp::Account] the account every test acts as.
  def account(company_id: nil) = Hcp::Account.new key: 'test-key', company_id: company_id

  # Answer the next read of this path with this body.
  def stub_read(path, body, query: {}, status: 200)
    stub_request(:get, "#{HOST}/#{path}").with(query: query).
      to_return status: status, body: body.to_json
  end
end

class Minitest::Test
  include HousecallStubs
end
