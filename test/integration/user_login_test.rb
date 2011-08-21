require 'test_helper'

class UserLoginTest < ActionController::IntegrationTest
  
  #fixtures :all

  def setup
    host! 'test'
    @company = companies(:one)

    @user = Factory.create(:user, :company_id=> @company.id)
    @user1 = Factory.create(:user, :company_id=> @company.id)

    @setting = settings(:one)#Setting.new(:id=>9991, :company_id => @user.company.id, :vat => 17.5, :logo => File.new("test/fixtures/sample_file.png"))
    @setting1 = settings(:two)#Setting.new(:id=>9992, :company_id => @user.company.id, :vat => 17.5, :logo => File.new("test/fixtures/sample_file.png"))
    @setting.save
    @setting1.save

    @user.company.setting = @setting
    @user1.company.setting = @setting1
    @user.save!
    @user1.save!

    #File.delete("public/system/logos/"+ @setting.id.to_s + "/sample_file.png")

  end

  def teardown
    @user = nil
    @user1 = nil
  end

 

  def test_redirects_when_not_signed_in

    host! @user1.company.name + ".test"
    logout_user
    get "/dashboard"
    follow_redirect!  
    assert_response :success
    assert_equal '/users/sign_in?unauthenticated=true', path
        
  end

  #todo
  #dashboard should not show null logo
  def test_user_edit_link
    login_user
    follow_redirect!
    assert_template ""
    get "/dashboard"    
    assert_response :success
    assert_equal @user.company.name + ".test", request.host
     assert_select "a[href=?]", edit_user_path(@user.id),
                :count=>1, :text=>"Edit Account"
  end

  def test_signin_valid

    login_user
    follow_redirect!   
    assert_template ""
    assert_equal @user.company.name + ".test", request.host
    
  end


  def test_signin_invalid_company
    
    get "users/sign_in"
    fill_in 'company', :with => @user1.company.name
    #fill_in 'username', :with => @user.username
    fill_in 'password', :with => @user.password
    click_button 'Sign in'
    assert !redirect?

    assert_template ""
    assert_equal '/users/sign_in', path
    assert_equal "test", request.host

  end

  def test_signin_invalid

    user = User.any_instance.stubs(:valid?).returns(false)

    get "users/sign_in"
    #assert_response :success
    #assert_template "sessions/new"
    post_via_redirect "users/sign_in",user.to_param#:username => user.username, :password => user.password, :company=> user.company.name
    #assert_template "sessions/new"
       
  end

  def test_changing_companies_after_singin_redirects_login_page
    login_user
    host! @user1.company.name + ".test"

    #assert_template ""
    #assert_equal '/users/sign_in', path    
  end

  def test_loggin_out_redirects_to_login_page
    login_user
    #get "users/sign_out"
    click_link "User Logout"
    follow_redirect!
    #assert_equal '/users/sign_in', path    
  end

  #def test_invalid_company_subdomain_relogin
  #  host! "badcompany.test"
  #  get "/clients/index"
  #  follow_redirect!   
  #  assert_equal '/users/sign_in?unauthenticated=true', path  
  #end

  def login_user
    get "users/sign_in"
    fill_in 'company', :with => @user.company.name
    fill_in 'email', :with => @user.email
    fill_in 'password', :with => @user.password
    click_button 'Sign in'
  end

  def logout_user
    get "users/sign_out"
    follow_redirect!
  end

  
end
