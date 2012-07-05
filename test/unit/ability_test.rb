require 'test_helper'
 
class AbilityTest < ActiveSupport::TestCase

  def setup

    admin_role = roles(:admin)
    standard_role = roles(:standard)
    viewer_role = roles(:viewer)
    client_role = roles(:client)

    @adminUser = FactoryGirl.build(:user)
    @adminUser.roles << admin_role
    @adminUser.owner = true
    @adminUser.save!

    @adminUserClient = FactoryGirl.build(:client, :company_id =>@adminUser.company_id)

    @standardUser = FactoryGirl.build(:user)
    @standardUser.roles << standard_role
    @standardUser.save!
    
    @contactAdminAbility = FactoryGirl.build(:contact, :client_id => @adminUserClient)

    @standardUserClient = FactoryGirl.build(:client, :company_id =>@standardUser.company_id)

    @viewerUser = FactoryGirl.build(:user)
    @viewerUser.roles << viewer_role
    @viewerUser.save

    @viewerUserClient = FactoryGirl.build(:client, :company_id =>@viewerUser.company_id)

    @client = FactoryGirl.create(:client)
    
    @contact = FactoryGirl.create(:contact, :client_id => @client.id)
    
    @clientUser = FactoryGirl.build(:user, :company_id =>@client.company_id,  :client_id => @client.id)
    @clientUser.roles << client_role
    @clientUser.save!

    @viewerUserClient = FactoryGirl.build(:client, :company_id =>@viewerUser.company_id)
       
    @adminAbility = Ability.new(@adminUser)
    @standardAbility = Ability.new(@standardUser)
    @viewerAbility = Ability.new(@viewerUser)
    @clientAbility = Ability.new(@clientUser)
  end
 
  def test_can_only_read_their_company
    assert @adminAbility.cannot?(:manage, Company.new)
    assert @adminAbility.cannot?(:read, Company.new)
    assert @adminAbility.can?(:read, @adminUser.company)
  end

  def test_admin_can_manage_invoice
    assert @adminAbility.cannot?([:update, :delete, :create], Company.new)    
    assert @adminAbility.can?(:manage, Invoice.new)
    assert @adminAbility.can?(:manage, InvoiceItem.new)
    assert @adminAbility.cannot?(:manage, Client.new)
    assert @adminAbility.can?(:manage, @adminUserClient)
    assert @adminAbility.can?(:manage, @contactAdminAbility)
    assert @adminAbility.can?(:manage, Delivery.new)
    assert @adminAbility.can?(:manage, Send.new)
    #assert @adminAbility.cannot?(:destroy, @adminUser)
    assert @adminAbility.can?(:read, Role.new)
    #todo
    #company_id column needs to be in invoice table
    assert @adminAbility.can?(:create, User.new)
    assert @adminAbility.can?(:read, @adminUserClient)
    assert @adminAbility.can?(:manage, Comment.new)
  end

  def test_standard_can_only_update_read_invoice
    #assert @standardAbility.can?([:create, :destroy], Invoice.new)
    assert @standardAbility.can?(:update, Invoice.new)
    assert @standardAbility.can?(:read, Invoice.new)
  end
  
  def test_standard_can_only_update_read_client
    assert @standardAbility.cannot?([:create, :destroy], Client.new)
    assert @standardAbility.cannot?(:update, @client)
    assert @standardAbility.cannot?(:update, Client.new)
    assert @standardAbility.cannot?(:read, Client.new)

    #assert @standardAbility.cannot?([:create, :destroy], @standardUserClient)
    assert @standardAbility.can?(:update, @standardUserClient)
    assert @standardAbility.can?(:update, @standardUserClient)
    assert @standardAbility.can?(:read, @standardUserClient)

    
  end

  def test_standard_can_only_update_his_account
    assert @standardAbility.cannot?([:update,:read], User.new)
    assert @standardAbility.can?(:update, @standardUser)
    assert @standardAbility.can?(:read, @standardUser)
  end
  
  def test_viewer_can_only_view_their_invoice_delivery
    
    assert @viewerUser.role? :viewer
        
    assert @viewerAbility.cannot?([:update, :create, :destroy], Invoice.new)
    assert @viewerAbility.can?(:read, Invoice.new)

    assert @viewerAbility.cannot?([:update, :create, :destroy], InvoiceItem.new)
    assert @viewerAbility.can?(:read, InvoiceItem.new)

    assert @viewerAbility.cannot?([:update, :create, :destroy], Delivery.new)
    assert @viewerAbility.can?(:read, Delivery.new)

    assert @viewerAbility.cannot?([:update, :create, :destroy], Send.new)
    assert @viewerAbility.can?(:read, Send.new)
  end

  def test_viewer_can_only_view_their_client
    assert @viewerAbility.cannot?([:update, :create, :destroy], Client.new)
    assert @viewerAbility.cannot?(:read, Client.new)

    assert @viewerAbility.cannot?([:update, :create, :destroy], @viewerUserClient)
    assert @viewerAbility.can?(:read, @viewerUserClient)

    assert @viewerAbility.cannot?([:update, :create, :destroy], Contact.new)
    assert @viewerAbility.can?(:read, @contact)
        
  end

  def test_viewer_can_only_update_his_account
    assert @viewerAbility.cannot?(:update, User.new)
    assert @viewerAbility.can?(:update, @viewerUser)
  end

  def test_all_can_comment
    assert @standardAbility.can?(:create, Comment.new)
    assert @standardAbility.can?(:read, Comment.new)
    assert @standardAbility.cannot?(:destroy, Comment.new)
    @comment = Comment.new
    @comment.user_id = @standardUser.id
    #assert @standardAbility.can?(:destroy,@comment)

  end

  def test_admin_can_invite_client_and_contact
    assert @adminAbility.cannot?([:update, :delete, :create], Company.new)
    assert @adminAbility.can?(:invite, @client)
    assert @adminAbility.can?(:invite, @contact)
    assert @standardAbility.cannot?(:invite, Client.new)
    assert @standardAbility.cannot?(:invite, Contact.new)
    assert @viewerAbility.cannot?(:invite, Client.new)
    assert @viewerAbility.cannot?(:invite, Contact.new)

  end

  def test_client


    assert @clientUser.role? :client
    assert @clientAbility.cannot?(:create, Client.new)
    assert_equal @clientUser.client_id, @client.id
    
    #assert @clientAbility.can? :manage, @client.contacts.new
    #assert @clientAbility.can?([:read, :update], @client)
    #assert @clientAbility.can?(:read, @client)

    assert @clientAbility.cannot?(:invite, Client.new)
    assert @clientAbility.cannot?(:invite, Contact.new)

    @invoice = FactoryGirl.create(:invoice, :client_id => @client.id)
    assert @clientAbility.cannot?([:create, :update, :destroy, :read], Invoice.new)
    assert @clientAbility.can?(:read, @invoice)    
  end




end
