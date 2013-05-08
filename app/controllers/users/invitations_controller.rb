class Users::InvitationsController < Devise::InvitationsController
    layout 'dashboard'

  # POST /resource/invitation
  def create
   
    
     @user = User.new
     @user.company_id = current_company.id
     @user.name = params[:user][:name]
     @user.email = params[:user][:email]
     

     
     if params[:user][:client_id]
       @user.client_id = params[:user][:client_id]
       @user.role_ids = [Role.find_by_name('Client').id] 
     else
       @user.role_ids = params[:user][:role_ids]
     end
     
     if @user.save
      @user.invite!#(:email => params[:user][:email])
 
      flash[:notice] = 'Invitation has been sent to user'
      redirect_to users_url
     else
        flash[:error] = @user.errors.full_messages.join(". ")

        render :new
        #super
     end   
     
     
  end
  
  def new
    #@name = ''
    #@email = ''
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
