class ContactsController < BaseController
  before_filter :find_client, :only => [:index, :new, :create, :destroy]
  load_and_authorize_resource :client
  load_and_authorize_resource :contact, :through => :client#, :shallow => true
  
  def index
  end

  def show    
  end
    
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create    
    respond_to do |format|

      if @contact.save
        flash[:notice] = "Contact was successfully created."
        format.html{redirect_to client_path(@client)}
        format.js {render :action => 'update'}
      else
        format.html{render :action => 'new'}
        format.js {render :action => 'new'}
      end
      
    end
  end
  
  def edit
    respond_to do |format|
      format.html
      format.js 
    end
  end
  
  def update
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html{redirect_to client_path(@client)}
        format.js {render :action => 'update'}
      else
        format.js {render :action => 'edit'}
      end
    end
  end
  
  def destroy    
  
    respond_to do | format |
      flash[:notice] = 'Contact was successfully removed.'
      
      #TODO
      #need to mark as deleted, because there could exist deliveries/reminders that relate to a devliery
      @contact.destroy      
      format.html{redirect_to client_path(@client)}
      format.js {render :action => 'update'}
    end
  end

  def new_invite
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
