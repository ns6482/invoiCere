require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

 def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".test"
    @invoice = invoices(:one)
    @invoice2 = invoices(:four)
    sign_in @user

  end

  def teardown
    sign_out @user
  end
  
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :invoice_id => @invoice
    assert_template 'show'
  end
  
  def test_new
    #@invoice = Factory.create(:invoice)
    get :new, :invoice_id => @invoice2.id
    assert_template 'new'
  end
  
  def test_create_invalid
    Schedule.any_instance.stubs(:valid?).returns(false)
    post :create, :invoice_id => @invoice, :schedule => {}
    assert_template 'new'
  end
  
  def test_create_valid
    Schedule.any_instance.stubs(:valid?).returns(true)
    Delivery.any_instance.stubs(:valid?).returns(true)
    post :create, :invoice_id => @invoice, :schedule => {}
    assert_redirected_to invoice_schedule_url(@invoice)
  end
  
  def test_edit  
    get :edit, :invoice_id => Schedule.first.invoice
    assert_template 'edit'
    #assert assigns(:delivery)
  end
  
  def test_update_invalid
    Schedule.any_instance.stubs(:valid?).returns(false)
    put :update, :invoice_id => Schedule.first.invoice
    assert_template 'edit'
  end
  
  def test_update_valid
    Schedule.any_instance.stubs(:valid?).returns(true)
    put :update, :invoice_id => Schedule.first.invoice
    assert_redirected_to invoice_schedule_url(Schedule.first.invoice)
  end
  
  def test_destroy
    schedule = Schedule.first
    delete :destroy,  :invoice_id => schedule.invoice
    assert_redirected_to schedules_url
    assert !Schedule.exists?(schedule.id)
  end

#  def test_new_if_exists_redirects
#    schedule = Schedule.first
#    schedule.save!
#    get :new, :invoice_id => @invoice
#    assert_redirected_to edit_invoice_schedule_url(Schedule.first.invoice)
#  end


end
