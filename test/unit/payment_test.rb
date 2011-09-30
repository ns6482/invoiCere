require 'test_helper'

class PaymentTest < ActiveSupport::TestCase


  def setup
   @invoice = Factory.create(:invoice, :tax_rate => 0, :state => "open")#invoices(:one)#Invoice.create( :tax_rate => 17.5, :title => "test", :invoice_date =>"01/01/2010", :client_id => 1)

   

   @item1 = InvoiceItem.create( :cost =>50, :qty => 1, :invoice_id => @invoice.id, :item_type=> "service", :item_description => "test1", :taxable => false)
   @item2 = InvoiceItem.create( :cost => 50, :qty => 1, :invoice_id => @invoice.id, :item_type=> "service", :item_description => "test2", :taxable => false)
   #item3 = InvoiceItem.create( :cost => 12.31, :qty => 3, :invoice_id => invoice.id, :item_type=> "service", :item_description => "test3")

   @invoice.invoice_items << @item1
   @invoice.invoice_items << @item2

   @invoice.save
   @invoice.run_callbacks(:save)
  
  end

#1. create invoice will total items of £100 pound
#2. assert payment remaining on invoice is equal to £100
#3. create payment for invoice with full set to true
#4. assert payment remaining on invoice is zero
#5. assert invoice.payments.count = 1

  def test_full_payment

     assert_equal("100",@invoice._total_cost.to_s)
     assert_equal("100.0", @invoice.remaining_amount.to_s)
     @payment = Factory.create(:payment, :amount=> 100, :invoice_id => @invoice.id)     
     assert_equal("0.0", @invoice.remaining_amount.to_s)
     assert_equal 1,  @invoice.payments.count
  end
  
#1. create invoice with total items of £100 pounds
#2. assert payment remaingin on invoice is equal to £100
#3. create payment partial flag true, amount greater than 100
#4. assert error on validation


   def test_overpayment_payment_not_allowed
     assert_equal("100",@invoice._total_cost.to_s)
     assert_equal("100.0", @invoice.remaining_amount.to_s)
     @payment = Factory.build(:payment, :amount=> 101, :invoice_id => @invoice.id)
     assert !@payment.save#, "Saved the post without a title"
     assert_equal("100.0", @invoice.remaining_amount.to_s)
     assert_equal 0,  @invoice.payments.count
  end

   def test_invoice_draft_payment_not_allowed


     invoice = Factory.create(:invoice, :tax_rate => 0, :state => "open")#invoices(:one)#Invoice.create( :tax_rate => 17.5, :title => "test", :invoice_date =>"01/01/2010", :client_id => 1)
     invoice.invoice_items << @item1
     invoice.invoice_items << @item2

     assert_equal("open", invoice.state)

     @payment = Factory.build(:payment, :amount=> 100, :invoice_id => invoice.id)
     assert !@payment.save#, "Saved the post without a title"

   end


#1. create invoice with total items of £100 pounds
#2. assert payment remaingin on invoice is equal to £100
#3. create payment partial flag true, amount of 50
#4. assert payment remaining is 50 pounds
#5. create payment partial flag true, amount 30
#6. assert payment remaining is 20 pounds
#7. create payment full flag true,
#8. assert amount is 20
#8. assert invoice.payments is 3

   def test_partial_payment
     assert_equal("100",@invoice._total_cost.to_s)
     assert_equal("100.0", @invoice.remaining_amount.to_s)

     @payment = Factory.build(:payment, :amount=> 50, :invoice_id => @invoice.id)
     assert @payment.save

     assert_equal("50.0", @invoice.remaining_amount.to_s)
     assert_equal 1,  @invoice.payments.count

     @payment = Factory.build(:payment, :amount=> 30, :invoice_id => @invoice.id)
     assert @payment.save!

     assert_equal("20.0", @invoice.remaining_amount.to_s)
     assert_equal 2,  @invoice.payments.count

     @payment = Factory.build(:payment, :amount=> 30, :invoice_id => @invoice.id)
     assert !@payment.save

     @payment = Factory.build(:payment, :amount=> 20, :invoice_id => @invoice.id)
     assert @payment.save

     assert_equal("0.0", @invoice.remaining_amount.to_s)
     assert_equal 3,  @invoice.payments.count
   end

  def test_full_payment
     assert_equal("100",@invoice._total_cost.to_s)
     assert_equal("100.0", @invoice.remaining_amount.to_s)

     @payment = Factory.build(:payment, :pay_full_amount=>"1", :invoice_id => @invoice.id)
     assert @payment.save

     assert_equal("0.0", @invoice.remaining_amount.to_s)
     assert_equal 1,  @invoice.payments.count
   end

  #create invoice,open, pay, cancel payment, check status reverted to open again

 # def test_status_open_from_paid
    #@payment = Factory.build(:payment, :invoice_id => @invoice.id, :pay_full_amount => "1")
    #assert @payment.save
    #@payment.run_callbacks(:save)    
  #end

end