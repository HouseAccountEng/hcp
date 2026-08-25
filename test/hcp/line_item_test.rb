require 'test_helper'

class LineItemTestCase < Minitest::Test
  # Housecall Pro answers a job's line items under `data` rather than under their own name.
  def test_reads_what_a_job_is_billed_as
    stub_read 'jobs/job_1/line_items', fixture('line_items'), query: { page: 1, page_size: 200 }

    line = Hcp::Job.new(node: { 'id' => 'job_1' }).line_items.first

    assert_equal 'Exterior trim - Fascia repair', line.name
    assert_includes line.description, 'Reattach or install'
    assert_equal 1.0, line.quantity
    assert_equal 330, line.unit_price
    assert_equal 0.5, line.unit_cost
    assert_equal 330, line.amount
    assert_equal :labor, line.kind
  end
end
