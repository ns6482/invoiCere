require 'test_helper'
require 'mocha'
require 'delorean'

class InvoiceTest < ActiveSupport::TestCase


  
  def test_should_be_valid
    invoice = FactoryGirl.create(:invoice)
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
    invoice = FactoryGirl.create(:invoice)
    assert(invoice.state =='draft')
  end

  def test_status_open
    invoice = FactoryGirl.build(:invoice, :state => "draft")    
    assert_equal "draft", invoice.state
    invoice.update_user = "test_user"
    invoice.open!
    assert_equal 'open', invoice.state
    assert_equal Date.today, invoice.opened_date
    assert_equal 'test_user', invoice.opened_by
   

  end

  def test_status_paid
    invoice = FactoryGirl.create(:invoice)
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
   assert_equal("2.5",@invoice.total_items.to_s)  
   assert_equal(250,@invoice._total_cost)    
   assert_equal(290,@invoice._total_cost_inc_tax)

   total_cost_inc_tax_delivery = @invoice.delivery_charge.to_i + @invoice._total_cost_inc_tax
   assert_equal(total_cost_inc_tax_delivery,@invoice._total_cost_inc_tax_delivery)

   assert_equal(305, @invoice.remaining_amount)

  end
  
  def test_discount_validation

    @invoice = invoices(:one)#Invoice.create( :tax_rate => 17.5, :title => "test", :invoice_date =>"01/01/2010", :client_id => 1)
    @invoice.discount = "1012"
    assert @invoice.save
    
    @invoice.discount = "10%"
    assert @invoice.save
    
    @invoice.discount = "20d"
    assert !@invoice.save

    assert_equal 1, @invoice.errors.size
    assert_equal @invoice.errors[:discount].count, 1
    
  end
  
  def test_total_with_discount

      @invoice = invoices(:one)#Invoice.create( :tax_rate => 17.5, :title => "test", :invoice_date =>"01/01/2010", :client_id => 1)

   item1 = invoice_items(:one)#InvoiceItem.create( :cost =>10.11, :qty => 1.5, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test1")
   item2 = invoice_items(:two)#InvoiceItem.create( :cost => 11.22, :qty => 2, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test2")
   #item3 = InvoiceItem.create( :cost => 12.31, :qty => 3, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test3")
    
   @invoice.invoice_items << item1
   @invoice.invoice_items << item2
   @invoice.discount = "10.00"
    
   @invoice.save
   #@invoice.run_callbacks(:after_save)
   @invoice.run_callbacks(:save)
  
   assert_equal(2,@invoice.invoice_items.length)
   assert_equal("2.5",@invoice.total_items.to_s)  
   assert_equal("240",@invoice._total_cost.to_s)    
   assert_equal("280",@invoice._total_cost_inc_tax.to_s)

  end
  
   def test_total_with_discount_perc

   @invoice = invoices(:one)#Invoice.create( :tax_rate => 17.5, :title => "test", :invoice_date =>"01/01/2010", :client_id => 1)

   item1 = invoice_items(:one)#InvoiceItem.create( :cost =>10.11, :qty => 1.5, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test1")
   item2 = invoice_items(:two)#InvoiceItem.create( :cost => 11.22, :qty => 2, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test2")
   #item3 = InvoiceItem.create( :cost => 12.31, :qty => 3, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test3")
    
   @invoice.invoice_items << item1
   @invoice.invoice_items << item2
   @invoice.discount = "10%"
    
   @invoice.save
   #@invoice.run_callbacks(:after_save)
   @invoice.run_callbacks(:save)
  
   assert_equal("225",@invoice._total_cost.to_s)    
   assert_equal("261",@invoice._total_cost_inc_tax.to_s)

  end


  
  def test_due_date
    @invoice = FactoryGirl.create(:invoice, :invoice_date => "01/01/2010", :due_days => 30)
    @invoice.save!
    assert_equal  Date.strptime("{ 2010, 1, 31 }", "{ %Y, %m, %d }"),@invoice.due_date
  end

  def test_due_date_equals_invoice_date_when_due_days_empty
    @invoice = FactoryGirl.create(:invoice, :invoice_date => "01/01/2010", :due_days => 0)
    @invoice.save!
    assert_equal  Date.strptime("{ 2010, 1, 01 }", "{ %Y, %m, %d }"),@invoice.due_date    
  end

  def test_formatted_state
    
    draft_invoice = FactoryGirl.create(:invoice, :state => 'draft')
    open_invoice = FactoryGirl.create(:invoice, :state => 'open', :invoice_date => Date.today-9, :due_days => 10)
    completed_invoice = FactoryGirl.create(:invoice, :state => 'paid')
    overdue_invoice = FactoryGirl.create(:invoice, :state => 'open', :invoice_date => Date.today-30, :due_days => 30)

    assert_equal("Draft",draft_invoice.formatted_state)
    assert_equal("Open",open_invoice.formatted_state)
    assert_equal("Completed",completed_invoice.formatted_state)
    assert_equal("Due", overdue_invoice.formatted_state)
  
  end

  def test_reminder_created
    invoice = FactoryGirl.create(:invoice)
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
