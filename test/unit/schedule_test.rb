require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Schedule.new.valid?
  end

  def test_instance_from_schedule
    schedule = schedules(:one)
    invoice = invoices(:one)

    schedule = Schedule.find_by_invoice_id(1)
    
    assert_equal false,  schedule.nil?
    assert_nil invoice.seed_schedule_id
    
    new_invoice = schedule.send_invoice!
    assert_equal schedule.id, new_invoice.seed_schedule_id.to_i
    assert !ActionMailer::Base.deliveries.empty?
  end

  def test_set_last_sent
    schedule = schedules(:one)
    schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.last_sent
    schedule.send_invoice!
    assert_equal Date.today.to_s, schedule.last_sent.to_s
   
  end
  
  def test_set_next_send
    schedule = schedules(:one)
    schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today + 1).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_daily
    schedule = schedules(:one)
    schedule.frequency = 2
    schedule.frequency_type = "Daily"
    schedule.save!

    schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today + 2).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_weekly
    schedule = schedules(:one)
    schedule.frequency = 2
    schedule.frequency_type = "Weekly"
    schedule.save!

    schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today + 14).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_monthly
    schedule = schedules(:one)
    schedule.frequency = 2
    schedule.frequency_type = "Monthly"
    schedule.save!

    schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today >> 2).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_yearly
    schedule = schedules(:one)
    schedule.frequency = 1
    schedule.frequency_type = "Yearly"
    schedule.save!

    schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today >> 12).to_s, schedule.next_send.to_s
  end

end
