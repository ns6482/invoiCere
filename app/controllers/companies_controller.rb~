class CompaniesController < BaseController
  load_and_authorize_resource :only => [:edit]
  skip_before_filter :check_logged_in, :only => [:new, :create]
  skip_before_filter :company_required, :only => [:new, :create]
  
  def index
  end
  
  def show
  end
  
  def new
    @company = Company.new
    @company.users.build
    
  end
  
  def create

    @company = Company.new#(params[:company])
    @company.name = params[:company][:name]

    @user = @company.users.new   
    @user.email = params[:company][:user][:email]
    @user.password = params[:company][:user][:password]
    @user.password_confirmation =params[:company][:user][:password_confirmation]
    @user.owner =true

    admin = Role.find_by_name("Admin")
    @user.roles << admin

    if @company.valid? and @user.valid?
      @company.save
      @user.company_id = @company.id
      @user.save
      flash[:notice] = "Successfully created company."
      sign_in_and_redirect(@user, :subdomain => @company.name)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @company.update_attributes(params[:company])
      flash[:notice] = "Successfully updated company."
      redirect_to root_path
    else        
      render :template => "companies/edit.html"
    end
  end
  
  def destroy
    @company.destroy
    flash[:notice] = "Successfully destroyed company."
    redirect_to companies_url
  end

  private
  
end

