require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  fixtures :items

  def setup
   # @company = companies(:two)
    @user = users(:user)# Factory.create(:user, :company_id => @company.id)
    
    #@invoices = @company.invoices
    @request.host = @user.company.name + ".lvh.me"#@company.name + ".test"
  
    #assert_equal @user.company.prefernce.discount, "10%"
  
    sign_in @user
 
  end

  def teardown
    sign_out @user
  end


  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Item.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Item.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to items_url#(assigns(:item))
  end

  def test_edit
    get :edit, :id => Item.first
    assert_template 'edit'
  end

  def test_update_invalid
    Item.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Item.first
    assert_template 'edit'
  end

  def test_update_valid
    Item.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Item.first
    assert_redirected_to item_url(assigns(:item))
  end

  def test_destroy
    item = Item.first
    delete :destroy, :id => item
    assert_redirected_to items_url
    assert !Item.exists?(item.id)
  end
end
