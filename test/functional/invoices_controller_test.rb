require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  fixtures :invoices, :clients, :companies # fixture_file_name ...

  def setup
   # @company = companies(:two)
    @user = users(:user)# Factory.create(:user, :company_id => @company.id)
    
    #@invoices = @company.invoices
    @request.host = @user.company.name + ".lvh.me"#@company.name + ".test"
  
    sign_in @user
 
  end

  def teardown
    sign_out @user
  end

  def test_index_by_company_one

    sign_out @user

    #@companyx = companies(:one)
    @user = users(:user)#Factory.create(:user, :company_id => @companyx.id)

    #@invoice = invoices(:one)#Factory.create(:invoice)
    #@invoices = @company.invoices
    @request.host = @user.company.name + ".lvh.me"#@companyx.name + ".test"

    sign_in @user

    get :index
    assert_template 'index'
    assert assigns :invoices
    assert_response :success
    assert_not_nil  :invoices

    assert_select "table#invoices" do
      assert_select "tr", :count => 2
    end
  end


  def test_index_by_company_two

    sign_out @user
    @user1 = users(:user1)#Factory.create(:user, :company_id => @companyx.id)

    sign_in @user1
    @request.host = @user1.company.name + ".lvh.me"#@companyx.name + ".test"
    
    get :index
    assert_template 'index'
    assert assigns :invoices
    assert_response :success
    assert_not_nil  :invoices

    assert_select "table#invoices" do
      assert_select "tr", :count => 3
    end

  end

  def test_show
    get :show, :id => Invoice.first
    assert_template 'show'
    assert assigns :invoice
    assert_response :success
  end

  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    invoice = Factory.attributes_for(:invoice, :id => 11, :client_id => nil)
    post :create, :invoice=> invoice
    assert_template 'new'
  end

  def test_create_valid
    
    
    Client.any_instance.stubs(:valid?).returns(true)
    Invoice.any_instance.stubs(:valid?).returns(true)
    client = Factory.create(:client, :company_name => "test", :company_id => @user.company_id)

    invoice = Factory.attributes_for(:invoice, :id => 1, :client_id => client.id)

    post :create, :invoice=> invoice
    assert assigns :invoice
    assert_equal 'Successfully created invoice.', flash[:notice]
    assert_redirected_to invoice_path(assigns(:invoice).id)
  end

#  def test_create_invalid_wrong_client

  #  @company = companies(:two)
  #  client = Factory.create(:client, :company_name => "test", :company_id => @company.id)

  #  invoice = Factory.attributes_for(:invoice, :id => 1, :client_id => client.id)
  #  post :create, :invoice=> invoice
  #  assert assigns :invoice
  #  assert_template 'new'

  #end

  def test_show
    get :show, :id => Invoice.first
    assert_response :success
    assert_template 'show'
  end

  def test_edit
    get :edit, :id => Invoice.first
    assert_response :success
    assert_template 'edit'
  end

  def test_update_invalid
    Invoice.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Invoice.first
    assert_template 'edit'
  end

  def test_update_valid
    Invoice.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Invoice.first
    assert_redirected_to invoice_url(assigns(:invoice))
  end

  def test_destroy
    invoice = Invoice.first
    delete :destroy, :id => invoice
    assert_redirected_to invoices_url
    assert !Invoice.exists?(invoice.id)
  end

  def test_default_date
    get :new
    assert_response :success
    @invoice = assigns(:invoice)
    assert_equal @invoice.invoice_date, Date.today
  end

  def test_initial_invoice_state_buttons
    @invoice = invoices(:one)
    get :show, :id => @invoice.id
    assert_response :success
    assert_equal "draft",@invoice.state

    assert_tag :li, :attributes => { :id => "open_invoice" }
    assert_no_tag :li, :attributes => { :id => "payment_invoice" }
  end

  def test_invoice_complete
    #@invoice = Factory.create(:invoice, :state => "draft")
    @invoice = invoices(:one)
    assert_equal "draft", @invoice.state
    put :update, :id => @invoice.id, :commit => "open"
    assert_response :found
    #assert_equal "open", invoice.state
    assert_equal 'Invoice is now open and ready for payment', flash[:notice]
    #assert_equal @user.email, invoice.opened_by
  end

   def test_invoice_pay
    @invoice2 = invoices(:one)
    @invoice2.open!
    #invoice2 = Factory.create(:invoice, :state => "open")
    assert_equal "open",@invoice2.state
    put :update, :id => @invoice2.id, :commit => "pay"
    #assert_equal  "paid", invoice2.state
    assert_response :found
    assert_equal 'Invoice marked as paid', flash[:notice]
    #assert_equal @user.email, invoice2.paid_by
   end

   def test_invoice_copy

     client = Factory.create(:client, :company_name => "test", :company_id => @user.company_id)
     invoice2 = Factory.create(:invoice, :client_id => client.id)
     get :new, :id =>invoice2.id
     #invoice = assert assigns(:invoice)
     #assert_false invoice.nil?
     #assert_equal invoice.title == invoice2.title
     #assert_equal invoice.id != invoice2.id
     assert_template 'new'
   end
   
end

