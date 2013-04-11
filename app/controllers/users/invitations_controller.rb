class Users::InvitationsController < Devise::InvitationsController
    layout 'dashboard'

  # POST /resource/invitation
  def create
    
     self.resource  = User.invite!(:email => params[:user][:email])
     self.resource .company_id = current_company.id
     self.resource .name = params[:user][:name]
     
     if params[:user][:client_id]
       self.resource.client_id = params[:user][:client_id]
       self.resource.role_ids = [Role.find_by_name('Client').id] 
     else
       self.resource .role_ids = params[:user][:role_ids]
     end
     
     self.resource .save!
    
     flash[:notice] = 'Invitation has been sent to user'
     redirect_to users_url
  end
  
  def new
    @name = ''
    @email = ''
    if params[:client_id]
      @client  =current_company.clients.accessible_by(current_ability).find(params[:client_id])
      
      @name = @client.name
      @email = @client.email
    end
    #TODO if params[:client_id] then hide set role name = 
    #client, hide  roles input (make hidden)
    @roles = Role.all(:conditions => ["name <> 'Client'"] )
   
   
 
    super
   
  end
#  def edit
#    super
#  end

end
