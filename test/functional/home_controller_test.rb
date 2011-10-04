require 'test_helper'

class HomeControllerTest < ActionController::TestCase
   include Devise::TestHelpers
  # Replace this with your real tests.

   def setup
    @company = companies(:two)
    @account = Factory.create(:account, :company_id => @company.id)
    @user = Factory.create(:user, :company_id => @company.id)   
    @request.host = @company.name + ".test"
  end

   def test_user_cannot_see_users_crud_link
    sign_in @user
    get :index
    assert_response :success 
    sign_out @user
   end

   def test_account_can_see_users_crud_link
     sign_in @account
     get :index
     assert_response :success     
     sign_out @account
   end
  
end
