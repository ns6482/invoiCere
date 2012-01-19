require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

 def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".lvh.me"
    @schedule = schedules(:one)
    @client= clients(:client1)
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
    #get :show, :invoice_id => @invoice
    #assert_template 'show'
  end
  
  def test_new
    #@invoice = Factory.create(:invoice)
    get :new, :client_id => @client.id
    assert_template 'new'
  end
  
  def test_create_invalid
    Schedule.any_instance.stubs(:valid?).returns(false)
    post :create, :client_id => @client.id, :schedule => {}
    assert_template 'new'
  end
  
  def test_create_valid
    Schedule.any_instance.stubs(:valid?).returns(true)
    Delivery.any_instance.stubs(:valid?).returns(true)
    post :create, :client_id => @client.id, :schedule => {}
    assert_redirected_to schedules_url
  end
  
  def test_edit  
    get :edit, :schedule_id => @schedule.id
    assert_template 'edit'
    #assert assigns(:delivery)
  end
  
  def test_update_invalid
    Schedule.any_instance.stubs(:valid?).returns(false)
    put :update, :schedule_id =>@schedule.id
    assert_template 'edit'
  end
  
  def test_update_valid
    Schedule.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @schedule
    assert_redirected_to schedules_url
  end
  
  def test_destroy
    delete :destroy,  :id => @schedule.id
    assert_redirected_to schedules_url
    assert !Schedule.exists?(@schedule.id)
  end

#  def test_new_if_exists_redirects
#    schedule = Schedule.first
#    schedule.save!
#    get :new, :invoice_id => @invoice
#    assert_redirected_to edit_invoice_schedule_url(Schedule.first.invoice)
#  end


end
