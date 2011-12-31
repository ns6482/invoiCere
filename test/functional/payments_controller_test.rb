require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".lvh.me"
    @invoice = invoices(:one)
    @invoice.state= "open"
    @invoice.save
    @payment = Factory.build(:payment, :invoice_id => @invoice.id, :user_id => @user.id)
    
    sign_in @user

  end

  def teardown
    sign_out @user
  end

  def test_index    
    get :index, :invoice_id => @invoice.id
    assert_template 'index'
  end


  def test_new
    get :new, :invoice_id => @invoice.id
    assert_template 'new'
  end

  def test_create_invalid    
    Payment.any_instance.stubs(:valid?).returns(false)    
    post :create, :invoice_id => @invoice.id
    assert_template 'new'
  end

  def test_create_valid
    Payment.any_instance.stubs(:valid?).returns(true)           
    post :create, :invoice_id =>@invoice.id,  :payment => {:invoice_id => @invoice.id, :amount => 10}    
    assert_redirected_to invoice_url(@invoice)
  end


  def test_new_already_paid
    post :create, :invoice_id =>@invoice.id,  :payment => {:invoice_id => @invoice.id, :pay_full_amount => "1"}    
    assert_equal 0, @invoice.remaining_amount.to_f
    get :new, :invoice_id => @invoice.id
    assert_redirected_to invoice_payments_url(@invoice)
  end

  def test_pay_draft_redirected
    
    @invoice.state = "draft"
    @invoice.save!
            
    get :new, :invoice_id => @invoice.id
    assert_redirected_to invoice_url(@invoice)
  end

  def test_destroy
    @invoice.state = "paid"
    @invoice.save!
    payment = Payment.first
    delete :destroy, :id => payment, :invoice_id => @invoice.id
    assert_redirected_to invoice_payments_url(@invoice)
    assert !Payment.exists?(payment.id)
  end
end
