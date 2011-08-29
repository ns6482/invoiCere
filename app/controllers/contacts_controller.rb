class ContactsController < BaseController
  #load_and_authorize_resource
  before_filter :find_client, :only => [:index, :new, :create]
  #  before_filter :find_contact, :only => [:show, :edit, :destroy]
  load_and_authorize_resource :client
  load_and_authorize_resource :contact, :through => :client, :shallow => true
  
  def index
    #@client = Client.find(params[:client_id])
    #@contacts = @client.contacts
  end

  def show    
    #@contact = Contact.find(params[:id])
  end
    
  def new
    #@client = Client.find(params[:client_id])
    #@contact = @client.contacts.build
  end
  
  def create
    #@client = Client.find(params[:client_id])
    #@contact = @client.contacts.build(params[:contact])
    
    if @contact.save
      flash[:notice] = "Contact was successfully created."
      redirect_to client_path(@client)
    else
      render :action => 'new'
    end
  end
  
  def edit
    #@contact = Contact.find(params[:id])
  end
  
  def update
    #@contact = Contact.find(params[:id])
    if @contact.update_attributes(params[:contact])
      flash[:notice] = 'Contact was successfully updated.'
      redirect_to client_path(@client)
    else
      render :action => 'edit'
    end
  end
  
  def destroy    
    #@contact = Contact.find(params[:id])
    #TODO
    #need to mark as deleted, because there could exist deliveries/reminders that relate to a devliery
    @contact.destroy
    flash[:notice] = 'Contact was successfully removed.'
    redirect_to client_path(@client)
  end

  def new_invite
    # @contact = Contact.find(params[:id])
  end

  def invite
    invite_contact          
    flash[:notice] = 'Invitation has been sent to contact'
    redirect_to contact_path(@client)
  end

  def find_client
    @client = current_company.clients.find(params[:client_id])
    @contacts = @client.contacts
  end

  def find_contact
    @contact = Contact.find_by_sql("SELECT id FROM contacts WHERE client_id = ? AND id = ?", @client.id, params[:id])
    #@contact = contacts.find(params[:id])
  end

  private


  def invite_contact
    @user = User.invite!(:email => @contact.email)
    @user.name = @contact.name
    @user.email = @contact.email
    @user.company_id = current_company.id
    @user.client_id = @contact.client.id
    @user.roles << Role.find_by_name("Client")#TODO change to client role
    #@user.send_invitation
    @user.save!
  end



end
