require 'simplecov'
SimpleCov.start { minimum_coverage 100 }

require 'minitest/autorun'
require 'webmock/minitest'

require_relative '../lib/hcp'

Hcp.key = 'test-key'

# Where Housecall Pro answers, and the canned replies every test builds on.
module HousecallStubs
  # Where every read goes.
  HOST = 'https://api.housecallpro.com'

  # @return [Hash] one of the recorded answers under test/fixtures.
  def fixture(name) = JSON File.read("test/fixtures/#{name}.json")

  # Answer the next read of this path with this body.
  def stub_read(path, body, query: {}, status: 200, headers: {})
    stub_request(:get, "#{HOST}/#{path}").with(query: query).
      to_return status: status, body: body.to_json, headers: headers
  end

  # Answer a page of records, as Housecall Pro wraps one.
  def stub_page(path, key, records, query: { page: 1, page_size: 200 }, total_pages: 1)
    stub_read path, { page: 1, page_size: 200, total_pages: total_pages,
      total_items: records.size, key => records, }, query: query
  end
end

class Minitest::Test
  include HousecallStubs
end
