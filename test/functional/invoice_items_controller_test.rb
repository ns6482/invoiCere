require 'test_helper'

class InvoiceItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => InvoiceItem.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    InvoiceItem.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    InvoiceItem.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to invoice_item_url(assigns(:invoice_item))
  end
  
  def test_edit
    get :edit, :id => InvoiceItem.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    InvoiceItem.any_instance.stubs(:valid?).returns(false)
    put :update, :id => InvoiceItem.first
    assert_template 'edit'
  end
  
  def test_update_valid
    InvoiceItem.any_instance.stubs(:valid?).returns(true)
    put :update, :id => InvoiceItem.first
    assert_redirected_to invoice_item_url(assigns(:invoice_item))
  end
  
  def test_destroy
    invoice_item = InvoiceItem.first
    delete :destroy, :id => invoice_item
    assert_redirected_to invoice_items_url
    assert !InvoiceItem.exists?(invoice_item.id)
  end
end
