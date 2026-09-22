require 'test_helper'

class AreasTest < Minitest::Test
  def test_the_zones_read_by_the_names_the_vocabulary_gives_them
    stub_read 'service_zones', { total_pages: 1, service_zones: [ downtown ] },
      query: { page: '1', page_size: '200' }

    areas = account.areas.to_a

    assert_equal %w[zone-1], areas.map(&:id)
    assert_equal 'Downtown', areas.first.name
    assert_equal %w[27601 27603], areas.first.zips
  end

private

  def downtown
    { id: 'zone-1', name: 'Downtown', coverage_type: 'zip_codes', zip_codes: %w[27601 27603],
      cities: [], service_pros: [], }
  end
end
