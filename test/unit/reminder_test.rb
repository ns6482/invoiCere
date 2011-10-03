require 'test_helper'

class ReminderTest < ActiveSupport::TestCase

  def setup
    @invoice = Factory.create(:invoice, :invoice_date => "01/01/2010", :due_days => 30)
    @reminder = @invoice.reminder
  end

  def test_should_be_invalid
    reminder = Factory.build(:reminder, :days_before => nil)
    assert !reminder.valid?
  end

  def test_should_be_valid
    reminder = Factory.build(:reminder, :days_before => 3)
    assert reminder.valid?
  end

  def test_next_send_default   
    expected_date = (@invoice.due_date - @reminder.days_before) + 7
    compare_date expected_date, @reminder.next_send
  end

  def test_next_send_date_default
    invoice = Factory.create(:invoice, :invoice_date => "01/01/2010", :due_days => 0) 
    compare_date(invoice.due_date, invoice.reminder.next_send)
    assert_nil @reminder.last_send
  end

  def test_next_send_date_normal
    invoice = Factory.create(:invoice, :invoice_date => "01/01/2010", :due_days => 3)
    expected_date = "2010-01-08 00:00:00 UTC"
    assert_equal expected_date.to_s, invoice.reminder.next_send.to_s   
  end

  def test_after_remind_sets_next_date
    
    n = Time.now
    ns = Time.gm(n.year, n.month, n.day, 0, 0)
    
    @reminder.remind
    assert_equal @reminder.frequency, "Weekly"
    assert_equal ns, @reminder.last_send
    assert_equal (ns +7.days), @reminder.next_send    

  end

  def compare_date (dt, dt2)
    assert_equal dt.year, dt2.year
    assert_equal dt.month, dt2.month
    assert_equal dt.day, dt2.day
  end
end
