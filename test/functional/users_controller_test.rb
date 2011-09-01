require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  fixtures :users
  setup :initialize_user
    
  def teardown    
    sign_out @user
    sign_out @standardUser
    @user = nil
    @standardUser = nil
  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => User.first
    assert_template 'show'
  end
  
  def test_new

    sign_out @standardUser
    sign_in @user

    get :new
    assert_response :success
    assert_template 'new'

    ## assert_select "ol" do
    #assert_select "li", 15
    ##  end
  end

  def test_new_standard

    sign_out @user    
    @request.host = @standardUser.company.name + ".lvh.me"
    sign_in @standardUser

    get :edit,:id =>@standardUser
    assert_response :success
    assert_template 'edit'

    ##assert_select "ol" do
    #assert_select "li",13
    ## end

  end

  def test_create_invalid
    company = companies(:two)    
    user = Factory.attributes_for(:user, :company_id => company.id, :email => "badmemail" )
    post :create,  :user => user
    assert_template 'new'
  end

  
  def test_create_valid
    company = companies(:two)
    user = Factory.attributes_for(:user, :company_id => company.id)
    post :create, :user => user
    assert_redirected_to user_url(assigns(:user))
  end
  
  def test_edit    
    get :edit, :id => @user
    assert_response :success
    assert_template 'edit'
  end
  

  #def test_update_invalid_admin_user
   # #User.any_instance.stubs(:valid?).returns(false)
    
    #put :update, :id => @user, :user => {:email => @user.email, :current_password => "password_wrong"}
    #assert_template 'edit'
  #end

  #def test_update_invalid_user_bad_password    
  #  sign_out @user

#    @request.host = @standardUser.company.name + ".lvh.me"
 #   sign_in @standardUser

#    User.any_instance.stubs(:valid?).returns(false)
 #   put :update, :id => @standardUser, :user => {:email => @standardUser.email, :current_password => "password_wrong"}
  #  assert_template 'edit'

   # sign_out @standardUser

    #sign_in @user

  #end

  
#  def test_update_valid
#    User.any_instance.stubs(:valid?).returns(true)
#    put :update, :id => @user, :user => {}
#    assert_redirected_to user_url(assigns(:user))
#  end
  
  def test_destroy
    user = users(:user)
    delete :destroy, :id => user
    assert_redirected_to users_url
    assert !User.exists?(user.id)
  end

  def test_user_redirected_index
    sign_out @user
    get :index
    assert_redirected_to "/users/sign_in"
    sign_out @user    
  end

  def test_user_redirected_create
    sign_out @user
    company = companies(:two)
    user = Factory.attributes_for(:user, :company_id => company.id)
    post :create, :user => user
    assert_redirected_to "/users/sign_in"
    sign_out @user
  end

  def test_user_redirected_edit   
    sign_out @user
    @user = users(:user)
    put :update, :id => @user#User.first
    assert_redirected_to "/users/sign_in"
    sign_out @user
  end

  def test_user_redirected_delete 
    sign_out @user
    user = users(:user)
    delete :destroy, :id => user
    assert_redirected_to "/users/sign_in"
    sign_out @user
  end

 #def login
 #   @user = users(:user)# Factory.create(:user, :company_id => @company.id)
 #   @request.host = @user.company.name + ".test"#@company.name + ".test"
#    sign_in @user
# end
 
 private
 
   def initialize_user
    @user= users(:user)
    @standardUser = users(:user2)
    @request.host = @user.company.name + ".lvh.me"
    sign_in @user
  end

end
