require 'test_helper'

class DeliveriesControllerTest < ActionController::TestCase  
   include Devise::TestHelpers
  
   def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".test"
    sign_in @user
    
  end

  def teardown
    sign_out @user
  end


 
  def test_new
    invoice = invoices(:one)#Factory.create(:invoice)
    get :new, :invoice_id => invoice.id
    assert_template 'new'
    assert_response :success
  end
  
   def test_create_invalid
    invoice = invoices(:one)
    #@delivery = Factory.build(:delivery)
    post :create, :invoice_id => invoice, :delivery =>{}
   # post :create, :delivery => @delivery.attributes
    assert_template 'new'
    assert_response :success
  end

   def test_show
    @invoice = invoices(:one)
    #@invoice.save!
    @delivery = Factory.build(:delivery, :invoice_id => @invoice.id)
    @delivery.contacts << Factory.build(:contact, :first_name => "A", :last_name=>"1")
    @delivery.save!
    get :show, :id => @delivery.id
    assert_template 'show'
    assert_response :success
  end

    def test_index
    @invoice = invoices(:one)
    #@invoice.save!
    @delivery = Factory.build(:delivery, :invoice_id => @invoice.id)
    @delivery.contacts << Factory.build(:contact, :first_name => "A", :last_name=>"1")
    @delivery.save!
    get :index, :invoice_id => @invoice.id
    assert_template 'index'
    assert_response :success
  end

end
