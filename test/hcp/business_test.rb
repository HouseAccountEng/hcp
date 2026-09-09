require 'test_helper'

class BusinessTestCase < Minitest::Test
  # Housecall Pro answers the account whole, rather than wrapped in a page or under a name.
  def test_reads_the_business_the_key_belongs_to
    stub_read 'company', fixture('company')

    business = account.business

    assert_equal '6513270e-269e-4d37-b2a7-4de452e6b438', business.id
    assert_equal 'Example Handyman Group HQ', business.name
    assert_equal '5555550100', business.phone
  end

  # Housecall Pro answers a franchise as a tree; the list reads it flat, the account first, so
  # a caller never walks it and a location at the foot of the tree is its own one subsidiary.
  def test_lists_itself_and_every_location_beneath_it
    stub_read 'company', fixture('company')

    subsidiaries = account.business.subsidiaries

    assert_equal [ 'Example Handyman Group HQ', 'Example Handyman Region',
                   'Example Handyman - Springfield', 'Example Handyman - Shelbyville', ],
      subsidiaries.map(&:name)
    assert_equal '5555550102', subsidiaries.last.phone
    assert_equal [ subsidiaries.last.id ], subsidiaries.last.subsidiaries.map(&:id)
  end

  def test_is_its_own_one_subsidiary_where_it_has_no_locations
    stub_read 'company', fixture('company_location')

    business = account.business

    assert_equal [ business.id ], business.subsidiaries.map(&:id)
  end
end
