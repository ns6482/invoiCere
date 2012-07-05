require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

   def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".lvh.me"
    sign_in @user

  end

  def teardown
    sign_out @user
  end
  
  def test_show
    get :show, :id => Feedback.first
    assert_template 'show'
  end
  
  def test_new
    invoice = invoices(:one)
    get :new,  :invoice_id => invoice
    assert_template 'new'
  end
  
  def test_create_invalid
    invoice = invoices(:one)
    Feedback.any_instance.stubs(:valid?).returns(false)
    post :create, :invoice_id => invoice, :feedback =>{}
    assert_template 'new'
    assert_response :success
  end
  
  def test_create_valid
    invoice = invoices(:one)
    Feedback.any_instance.stubs(:valid?).returns(true)
    post :create,  :invoice_id => invoice, :feedback =>{}
    assert_redirected_to feedback_url(assigns(:feedback))
  end
  
  def test_edit
    f = Feedback.first
    f.save!
    get :edit, :id => f.id
    assert_template 'edit'
  end
  
  def test_update_invalid
    invoice = invoices(:one)
    Feedback.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Feedback.first,  :feedback =>{}
    assert_template 'edit'
  end
  
  def test_update_valid
    Feedback.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Feedback.first , :feedback =>{}
    assert_redirected_to feedback_url(assigns(:feedback))
  end
  
  def test_destroy
    invoice = invoices(:one)
    feedback = Feedback.first
    delete :destroy, :id => feedback,  :invoice_id => invoice, :feedback =>{}
    assert_redirected_to invoice_url(invoice)
    assert !Feedback.exists?(feedback.id)
  end
end
