require 'test_helper'
require 'mocha'
require 'delorean'


class InvoiceTest < ActiveSupport::TestCase


  
  def test_should_be_valid
    invoice = Factory.create(:invoice)
    assert invoice.valid?
  end

  def test_failing_invoice
    invoice = Invoice.new
    assert !invoice.save
    assert_equal 4, invoice.errors.size

    assert_equal invoice.errors[:title].count, 1
    assert_equal invoice.errors[:invoice_date].count, 1
    assert_equal invoice.errors[:client_id].count, 1
    assert_equal invoice.errors[:due_days].count, 1

    
  end

  def test_initial_status
    invoice = Factory.create(:invoice)
    assert(invoice.state =='draft')
  end

  def test_status_open
    invoice = Factory.build(:invoice, :state => "draft")    
    assert_equal "draft", invoice.state
    invoice.update_user = "test_user"
    invoice.open!
    assert_equal 'open', invoice.state
    assert_equal Date.today, invoice.opened_date
    assert_equal 'test_user', invoice.opened_by
   

  end

  def test_status_paid
    invoice = Factory.create(:invoice)
    invoice.update_user = 'test_user'
    invoice.open!
    invoice.pay!
    assert(invoice.state =='paid')
    assert_equal Date.today, invoice.paid_date
    assert_equal 'test_user', invoice.paid_by

  end



  def test_total

   @invoice = invoices(:one)#Invoice.create( :tax_rate => 17.5, :title => "test", :invoice_date =>"01/01/2010", :client_id => 1)

   item1 = invoice_items(:one)#InvoiceItem.create( :cost =>10.11, :qty => 1.5, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test1")
   item2 = invoice_items(:two)#InvoiceItem.create( :cost => 11.22, :qty => 2, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test2")
   #item3 = InvoiceItem.create( :cost => 12.31, :qty => 3, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test3")
    
   @invoice.invoice_items << item1
   @invoice.invoice_items << item2

   @invoice.save
   #@invoice.run_callbacks(:after_save)
   @invoice.run_callbacks(:save)
  
   assert_equal(2,@invoice.invoice_items.length)
   assert_equal(19.98,@invoice.total_items)  
   assert_equal("199.6002",@invoice._total_cost.to_s)    
   assert_equal("209.57022999",@invoice._total_cost_inc_tax.to_s)

   total_cost_inc_tax_delivery = @invoice.delivery_charge.to_f + 209.57022999
   assert_equal(total_cost_inc_tax_delivery.to_s,@invoice._total_cost_inc_tax_delivery.to_s)

   assert_equal("189.56022999", @invoice.remaining_amount.to_s)

  end

  def test_due_date
    @invoice = Factory.create(:invoice, :invoice_date => "01/01/2010", :due_days => 30)
    @invoice.save!
    assert_equal  Date.strptime("{ 2010, 1, 31 }", "{ %Y, %m, %d }"),@invoice.due_date
  end

  def test_due_date_equals_invoice_date_when_due_days_empty
    @invoice = Factory.create(:invoice, :invoice_date => "01/01/2010", :due_days => 0)
    @invoice.save!
    assert_equal  Date.strptime("{ 2010, 1, 01 }", "{ %Y, %m, %d }"),@invoice.due_date    
  end

  def test_formatted_state
    
    draft_invoice = Factory.create(:invoice, :state => 'draft')
    open_invoice = Factory.create(:invoice, :state => 'open', :invoice_date => Date.today-9, :due_days => 10)
    completed_invoice = Factory.create(:invoice, :state => 'paid')
    overdue_invoice = Factory.create(:invoice, :state => 'open', :invoice_date => Date.today-30, :due_days => 30)

    assert_equal("Draft",draft_invoice.formatted_state)
    assert_equal("Open",open_invoice.formatted_state)
    assert_equal("Completed",completed_invoice.formatted_state)
    assert_equal("Payment Due", overdue_invoice.formatted_state)
  
  end

  def test_reminder_created
    invoice = Factory.create(:invoice)
    #assert_not_nil invoice.reminder
  end

  #def test_clone_with_associations
    #invoice = invoices(:one)    
    #invoice.save

    #new_invoice = invoice.clone_with_associations
    #assert_equal invoice.client_id, new_invoice.client_id
    #assert_equal invoice.invoice_date, new_invoice.invoice_date
    #assert_not_equal invoice.id, new_invoice.id
    #assert_equal 2, new_invoice.invoice_items.count
    ##assert_not_equal invoice.reminder.id,  new_invoice.reminder.id
    ##assert_not_nil new_invoice.reminder  
  #end
  
  


  
end
