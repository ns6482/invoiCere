require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # called before every single test

 fixtures :users, :clients, :companies # fixture_file_name ...
  def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".lvh.me"
    sign_in @user
  end
 
  def teardown
    sign_out @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)

  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do

    assert_equal Client.count, 3 
    assert_difference('Client.count') do
      post :create,  :client =>Factory.attributes_for(:client)
    end
    assert_equal 'Client was successfully created.', flash[:notice]
    assert_redirected_to clients_path()
  end

  def test_create_invalid

    Client.any_instance.stubs(:valid?).returns(false)
    post :create 
    assert_template 'new'
  end

  test "should show client" do
    get :show, :id => clients(:client1)
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => clients(:client1).to_param
    assert_response :success
  end

  test "should update client" do
    put :update, :id => clients(:client1).to_param, :client => { }
    assert_redirected_to client_path(assigns(:client))
    assert_equal 'Client was successfully updated.', flash[:notice]
  end

  def test_update_invalid

    Client.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Client.first, :company => Company.first
    assert_template 'edit'
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, :id => clients(:client1).to_param
      assert_equal 'Client was successfully removed.', flash[:notice]
    end
    assert_redirected_to clients_path
  end

  test "should display contacts on client page" do
    get :show, :id => clients(:client1)
    assert_response :success
    assert_select "div#contacts tr", 1
  end

  test "should display no contacts when contacts empty" do
    get :show, :id => clients(:client3)
    assert_response :success
    assert_select "div#contacts", :text => /No contacts/
  end

  def test_invite
    @client= clients(:client1)
    put :invite , :id => @client.id
    assert_equal 'Invitation has been sent to client', flash[:notice]
    assert_redirected_to client_path(@client)
    assert assigns :user
    @user = assigns :user

    assert_equal @client.company_id, @user.company_id
    assert_equal @client.id, @user.client_id
    assert_equal !!@user.roles.find_by_name("Client"), true
  end



end
