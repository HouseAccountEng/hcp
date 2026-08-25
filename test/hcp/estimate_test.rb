require 'test_helper'

class EstimateTestCase < Minitest::Test
  def setup
    @estimate = Hcp::Estimate.new node: fixture('estimate')
  end

  def test_reads_what_was_offered_and_who_it_was_offered_to
    assert_equal 'csr_2ac4e89ea3f94fba99145285fb7bbce5', @estimate.id
    assert_equal '51108564', @estimate.estimate_number
    assert_equal :scheduled, @estimate.work_status
    assert_equal 'HouseAccount', @estimate.lead_source
    assert_equal 'Ada', @estimate.customer.name
    assert_equal :service, @estimate.address.type
    assert_equal Time.utc(2026, 6, 21, 13, 39, 50), @estimate.created_at
  end

  def test_reads_the_pro_the_estimate_is_assigned_to
    pro = @estimate.assigned_employees.first

    assert_equal 'Ada Example', pro.name
    assert_equal 'ada@example.com', pro.email
    assert_equal '5550000001', pro.phone
    assert_equal 'admin', pro.role
    assert_equal Time.utc(2026, 5, 6, 19, 44, 42), pro.created_at
  end

  def test_reads_each_option_the_customer_was_offered_priced_on_its_own
    option = @estimate.options.first

    assert_equal 'Option #1', option.name
    assert_equal '51108564', option.option_number
    assert_equal 0, option.total_amount
    assert_nil option.approval_status
    assert_equal 'submitted for signoff', option.status
    assert_includes option.message_from_pro, 'Thank you'
    assert_equal [ 'Pipeline Automation' ], option.tags
    assert_equal 'No phone (estimate $20–$50)', option.notes.first.content
    assert_equal Time.utc(2026, 6, 22, 13, 45, 9), option.updated_at
  end
end
