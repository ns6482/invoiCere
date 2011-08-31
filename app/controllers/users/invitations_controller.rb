class Users::InvitationsController < Devise::InvitationsController
  # POST /resource/invitation
  def create
    
     self.resource  = User.invite!(:email => params[:user][:email])
     self.resource .company_id = current_company.id
     self.resource .role_ids = params[:user][:role_ids]
     self.resource .name = params[:user][:name]
     self.resource .save!
    
     flash[:notice] = 'Invitation has been sent to user'
     redirect_to users_url
  end
  
#  def edit
#    super
#  end

end
