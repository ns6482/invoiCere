require 'test_helper'

class UserSignupTest < ActionController::IntegrationTest


  def setup
    host! 'test'
  end

  def teardown

  end

 # def test_after_signup_redirects
   
   # get "users/sign_up"
   # assert_response :success
   # assert_template "registrations/accounts/new"

    #fill_in 'company', :with => "foo1"#user.company.name
    #fill_in 'email', :with => "foo1@foo.com"#user.email
    #fill_in 'password', :with => "password"#user.password
    #fill_in 'password confirmation', :with => "password" #user.password
    #click_button 'Create Account'

    #@account = assigns(:account)
    #assert @account

#    assert_equal @account.email, "foo1@foo.com"
##    assert_true @account.owner
 #   assert_response :redirect
 #   follow_redirect!

  #  assert_template ""
  #  assert_equal "foo1.test", request.host

#  end


  
end
