class UsersController < BaseController
  load_and_authorize_resource :user

  before_filter :check_admin
  before_filter :accessible_roles, :except => [:index]
  before_filter :authorize_company
  before_filter :get_users, :only => [:index]
  before_filter :check_password_required, :only => [:edit, :update]

  def index
    @clients = current_company.clients.accessible_by(current_ability).users
    
  end
  
  
  def new       
  end
  
  def create

    @user.company_id = current_company.id  
   
    #@user.role_ids = params[:user][:role_ids]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    #
    # @user.email = params[:user][:email]
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    #@user.email = params[:user][:email]
    
  end
  
  def update
    
    begin
    @user.update_attribute(:email,  params[:user][:email])
    @user.update_attribute(:password,  params[:user][:password])
    
    if @password_required
      update_user(@user.update_with_password(params[:user]))
    else
      update_user(@user.update_without_password(params[:user]))
    end
    
    #@user.update_attribute(:roles_ids, params[:user][:role_ids])
   
   rescue ActiveRecord::RecordNotUnique
     flash[:error] = "Please choose another email address"
     render :action => 'edit'
   end
    
    
  end
  
  def destroy    
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    redirect_to users_url
  end

  def new_invite
    @user = User.new
    #@user.company = current_company
  end

  def invite        
    #@user.resend_invitation!
            
    @user = User.invite!(:email => params[:user][:email])
    @user.company_id = current_company.id
    @user.role_ids = params[:user][:role_ids]
    @user.name = params[:user][:name]
    @user.save!

    flash[:notice] = 'Invitation has been sent to user'
    redirect_to users_url
  end

  private

  def update_user (success)
    if success
      flash[:notice] = "Successfully updated user."
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end

  def accessible_roles
    @accessible_roles = Role.accessible_by(current_ability,:read)
  end

  def authorize_company
    authorize! :read, current_company
  end

  def get_users
    
    @users = current_company.users.accessible_by(current_ability,:read).find(:all, :conditions => ["client_id IS NULL"])
 
  end

  def check_admin    
      if user_signed_in?
        return current_user.role?(:admin)
    end
  end

  def check_password_required
    @password_required = false

    if user_signed_in?
      @password_required = (current_user == @user)
    end
  end
  

end
