require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user= users(:user)
    @standardUser = users(:user2)
#    @account = Factory.create(:account)
 #   account_login
    user_login
  end

  def user_login      
    @request.host = @user.company.name + ".test"
    sign_in @user
  end

  def teardown
    sign_out @user
    sign_out @standardUser
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  #def test_show
  #  get :show, :id => User.first
  #  assert_template 'show'
  #end
  
  #def test_new

   # sign_out @standardUser
   # sign_in @user
    ##user_login

    #get :new
    #assert_response :success
    #assert_template 'new'

    ## assert_select "ol" do
    #assert_select "li", 15
    ##  end

  #end

  #def test_new_standard

    #sign_out @user    

    #@request.host = @standardUser.company.name + ".test"
    #sign_in @standardUser

    #get :edit,:id =>@standardUser
    #assert_response :success
    #assert_template 'edit'

    ##assert_select "ol" do
    #assert_select "li",13
    ## end

  #end

  #def test_create_invalid
  #  company = companies(:two)    
  #  user = Factory.attributes_for(:user, :company_id => company.id, :email => "badmemail" )
  #  post :create,  :user => user
  #  assert_template 'new'
  #end

  
  #def test_create_valid
  #  company = companies(:two)
  #  user = Factory.attributes_for(:user, :company_id => company.id)
  #  #User.any_instance.stubs(:valid?).returns(true)
  #  post :create, :user => user
  #  assert_redirected_to user_url(assigns(:user))
  #end
  
  #def test_edit    
  #  get :edit, :id => @user#User.first
  #  assert_response :success
  #  assert_template 'edit'
  #end
  
  #def test_update_invalid_admin_user
  #  #@user = users(:user)
   # #User.any_instance.stubs(:valid?).returns(false)
   # put :update, :id => @user, :user => {:email => 'bademail'}#{:email => "nehal.soni@gmail.com"}#, :current_password => "password_wrong"}
  #  assert_template 'edit'
  #end

  #def test_update_invalid_user_bad_password    
#    sign_out @user

#    @request.host = @standardUser.company.name + ".test"
 #   sign_in @standardUser

  #  #User.any_instance.stubs(:valid?).returns(false)
  #  put :update, :id => @standardUser, :user => {:email => @standardUser.email, :current_password => "password_wrong"}
  #  assert_template 'edit'

#    sign_out @standardUser

 #   sign_in @user

#  end

  
  #def test_update_valid
  #  @user = users(:user)    
  #  put :update, :id => @user, :user => {:email => "nehal.soni@gmail.com", :current_password => "password"}
  #  assert_redirected_to user_url(assigns(:user))
  #end
  
  #def test_destroy
  #  user = users(:user)#Factory.create(:user)
  #  delete :destroy, :id => user
  #  assert_redirected_to users_url
  #  assert !User.exists?(user.id)
  #end

  #def test_user_redirected_index
#    sign_out @user
#    #user_login
#    get :index
#    assert_template ''
#    assert_redirected_to "/users/sign_in?unauthenticated=true"
#    sign_out @user
 #   sign_in @account
 # end

  #def test_user_redirected_create
  #  sign_out @user
  #  #user_login
  #  company = companies(:two)
  #  user = Factory.attributes_for(:user, :company_id => company.id)
  #  post :create, :user => user
  #  assert_template ''
  #  assert_redirected_to "/users/sign_in?unauthenticated=true"
  #  sign_out @user
 # end

  #def test_user_redirected_edit
   
#    sign_out @user
#    #user_login
#    @user = users(:user)
#    #User.any_instance.stubs(:valid?).returns(true)
#    put :update, :id => @user#User.first
#    assert_template ''
#    assert_redirected_to "/users/sign_in?unauthenticated=true"
#    sign_out @user
#  end

#  def test_user_redirected_delete 
#    sign_out @user
#    #user_login
#    user = users(:user)#Factory.create(:user)
#    delete :destroy, :id => user
#    assert_template ''
#    assert_redirected_to "/users/sign_in?unauthenticated=true"
#    sign_out @user
#  end

#  def test_invite 
#    @user = Factory.attributes_for(:user)    
#    User.any_instance.stubs(:valid?).returns(true)
#    post :invite , :user => @user
#    assert_equal 'Invitation has been sent to user', flash[:notice]
#    assert_redirected_to users_path 
#  end

 def login
    @user = users(:user)# Factory.create(:user, :company_id => @company.id)
    @request.host = @user.company.name + ".test"#@company.name + ".test"
    sign_in @user
 end
end
