require 'test_helper'

class InvoiceItemsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  fixtures :invoice_items, :invoices, :clients, :companies # fixture_file_name ...

  
  def setup
    @user = users(:user)# Factory.create(:user, :company_id => @company.id)    
    @request.host = @user.company.name + ".lvh.me"#@company.name + ".test"  
    @invoice = Invoice.first
    @invoice_item = InvoiceItem.first
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
    InvoiceItem.any_instance.stubs(:valid?).returns(false)
    post :create, :invoice_id => @invoice.id
    assert_template 'new'
  end
  
  def test_create_valid
      
    InvoiceItem.any_instance.stubs(:valid?).returns(true)
    post :create, :invoice_id => @invoice.id, :invoice_item =>@invoice_item.attributes
    assert_redirected_to invoice_item_url(assigns(:invoice_item))
  end
  
  def test_edit
    get :edit, :id => @invoice_item
    assert_template 'edit'
  end
  
  def test_update_invalid
    InvoiceItem.any_instance.stubs(:valid?).returns(false)
    put :update, :id => @invoice_item
    assert_template 'edit'
  end
  
  def test_update_valid
    InvoiceItem.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @invoice_item
    assert_redirected_to invoice_item_url(assigns(:invoice_item))
  end
  
  def test_destroy
    invoice_item = InvoiceItem.first
    delete :destroy, :id => invoice_item.id
    assert_redirected_to invoice_invoice_items_url(invoice_item.invoice.id)
    assert !InvoiceItem.exists?(invoice_item.id)
  end
end
