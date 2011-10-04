require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @company = companies(:two)
    @account = Factory.create(:account, :company_id => @company.id)
    @adminUser = users(:user1)
    @standardUser = users(:user2)
    #@user = Factory.create(:user, :company_id => @company.id)
    @request.host = @company.name + ".test"

    sign_in @account
  end
#
#  def test_account_can_see_users_crud_link
#    test_user_crud @account
#  end
#
#  def test_admin_user_can_see_users_crud_link
#    test_user_crud @adminUser
#  end
#
#  def test_user_cannot_see_users_crud_link
#    test_no_user_crud @standardUser
#  end


#  def test_user_crud (user)
#    sign_in user
#    get :index
#    assert_response :success
#    assert_select 'title', "Dashboard"
#    get :index
#    assert_response :success
#    assert_select 'ul.navigation' do
#      assert_select 'a', "Users"
#    end
#
#    sign_out user
#  end
#
#  def test_no_user_crud (user)
#    sign_in user
#    get :index
#    assert_response :success
#  assert_select "a", { :count => 0, :html => /Users/ }
#    sign_out user
#  end

  def test_index
  #  get :index, :month =>'2011-01-01'
    #assert_template 'index'
    #assert_response :success
  end

end
