require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  
  def test_should_be_invalidvalid
    assert !Schedule.new.valid?
  end

  def test_instance_from_schedule
    schedule = schedules(:one)
    
    invoice = invoices(:one)

    #schedule = Schedule.find_by_invoice_id(1)
    
    assert_equal false,  schedule.nil?
    
    #assert 15, schedule.due_on
   
    
    
    new_invoice = schedule.send_invoice!
    #assert_equal schedule.id, new_invoice.seed_schedule_id.to_i
    assert !ActionMailer::Base.deliveries.empty?
  end

  def test_set_last_sent
    schedule = schedules(:one)
    #schedule = Schedule.find_by_invoice_id(1)
    assert_nil schedule.last_sent
    schedule.send_invoice!
    assert_equal Date.today.to_s, schedule.last_sent.to_s
   
  end
  
  def test_set_next_send
    schedule = schedules(:one)
    #schedule = Schedule.find_by_invoice_id(1)
    #assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today + 1).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_daily
    schedule = schedules(:one)
    schedule.frequency = 2
    schedule.frequency_type = "Daily"
    schedule.save!

    #schedule = Schedule.find_by_invoice_id(1)
    #assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today + 2).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_weekly
    schedule = schedules(:one)
    schedule.frequency = 2
    schedule.frequency_type = "Weekly"
    schedule.save!

    #schedule = Schedule.find_by_invoice_id(1)
    #assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today + 14).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_monthly
    schedule = schedules(:one)
    schedule.frequency = 2
    schedule.frequency_type = "Monthly"
    schedule.save!

    #schedule = Schedule.find_by_invoice_id(1)
    #assert_nil schedule.next_send
    schedule.send_invoice!
    assert_equal (Date.today >> 2).to_s, schedule.next_send.to_s
  end

  def test_set_next_send_frequency_yearly
    
    val = Invoice.count
    schedule = schedules(:one)
    schedule.frequency = 1
    schedule.frequency_type = "Yearly"
    
    schedule.schedule_items << schedule_items(:one)
    schedule.schedule_items << schedule_items(:two)
   
    schedule.save!

    #schedule = Schedule.find_by_invoice_id(1)
    #assert_nil schedule.next_send
    invoice = schedule.send_invoice!
    
    assert_equal Invoice.count, val+1
    assert_equal (Date.today >> 12).to_s, schedule.next_send.to_s


    assert_equal schedule.schedule_items.count, invoice.invoice_items.count
    
  end
  
  


end
