require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
   
  def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".test"
    sign_in @user

    @contact = contacts(:contact1)
    @client = clients(:client1)

  end

  def teardown
    sign_out @user
  end

  def test_index
    get :index, :client_id => @client
    assert_template 'index'
    assert_response :success
  end
  
  def test_show
    get :show, :id => @contact
    assert_template 'show'
    assert_response :success
  end

  def test_new
    get :new, :client_id => @client
    assert_template 'new'
    assert_response :success
  end
  
  def test_create_invalid
    post :create, :client_id => @client, :contact =>{}
    assert_template 'new'
    assert_response :success
  end

  def test_create_valid
    post :create, :client_id => @client, :contact =>@contact.attributes
    assert_equal 'Contact was successfully created.', flash[:notice]
    assert_redirected_to client_path(@client)
  end

  def test_edit
    #contact = contacts(:contact1)#Factory.create(:contact)
    get :edit, :id => @contact
    assert_template 'edit'
    assert_response :success
  end

  def test_update_invalid
    Contact.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Contact.first
    assert_template 'edit'
    assert_response :success
  end

  def test_update_valid
    #Contact.any_instance.stubs(:valid?).returns(true)
    #contact = contacts(:contact1)#Factory.create(:contact)
    put :update, :id => @contact
    assert_equal 'Contact was successfully updated.', flash[:notice]    
    assert_redirected_to client_path(@contact.client)
  end

  def test_destroy    
    delete :destroy, :id=> @contact
    assert_redirected_to client_path(@client)
    assert_equal 'Contact was successfully removed.', flash[:notice]
    assert !Contact.exists?(@contact)
  end

  def test_new_invite
    get :new_invite , :id => @contact
    assert_template 'new_invite'
    assert_response :success
  end

  def test_invite
    put :invite , :id => @contact
    assert_equal 'Invitation has been sent to contact', flash[:notice]
    assert_redirected_to contact_path(@contact)
    assert assigns :user
    @user = assigns :user
    
    assert_equal @contact.client.company_id, @user.company_id
    assert_equal @contact.client.id, @user.client_id
    assert_true @user.role? "Client"
  end
end
