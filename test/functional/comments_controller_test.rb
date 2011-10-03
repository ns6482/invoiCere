require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
   include Devise::TestHelpers

   def setup
    @invoice = invoices(:one)        
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".lvh.me"
    sign_in @user
  end

  def teardown
    sign_out @user
  end

  def test_index
    get :index, :invoice_id=> @invoice.id
    assert_template 'index'
  end
      
  def test_new
    get :new, :invoice_id => @invoice.id
    assert_template 'new'
  end

  def test_create_invalid
    post :create, :invoice_id => @invoice.id, :comment =>{}
    assert_template 'new'
  end

  def test_create_valid
    Comment.any_instance.stubs(:valid?).returns(true)
    post :create, :invoice_id => @invoice.id
    assert_redirected_to invoice_comments_url(@invoice)
  end

#  def test_edit
#    get :edit, :id => Comment.first
#    assert_template 'edit'
#  end
#
#  def test_update_invalid
#    Comment.any_instance.stubs(:valid?).returns(false)
#    put :update, :id => Comment.first
#    assert_template 'edit'
#  end
#
#  def test_update_valid
#    Comment.any_instance.stubs(:valid?).returns(true)
#    put :update, :id => Comment.first
#    assert_redirected_to comment_url(assigns(:comment))
#  end

  def test_destroy
    comment = Comment.first
    delete :destroy, :id => comment, :invoice_id => @invoice.id
    assert_redirected_to invoice_comments_url(@invoice)
    assert !Comment.exists?(comment.id)
  end
end
