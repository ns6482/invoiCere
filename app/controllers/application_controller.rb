class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  layout 'application'
  
  before_filter :set_mailer_url_options


  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  helper :all # include all helpers, all the time  
  before_filter :check_user_belongs_to_company, :set_email_host

  # Will either fetch the current account or return nil if none is found
  def current_company
    @company ||= Company.find_by_name(current_subdomain)
  end

  def set_email_host
    if  !current_company.nil?
      ActionMailer::Base.default_url_options[:host] =request.host_with_port
    end  
  end
  
  # Make this method visible to views as well
  helper_method :current_company

  # This is a before_filter we'll use in other controllers
  def company_required
    unless current_company
      if current_user
        redirect_to new_user_session_path(:subdomain => false)
      end
    end
  end

  def check_user_belongs_to_company
    if  current_user and current_company
      if  current_user.company_id != current_company.id
        redirect_to destroy_user_session_url(:subdomain => false)
      end
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) 
      name = Company.find(resource.company_id).name
      root_url(:subdomain => name )    
    else
     super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    super
    if current_user
      new_user_session_path    
    end
  end

  def current_subdomain
    request.subdomain
  end

  def current_ability
    if user_signed_in?
      @current_ability ||= Ability.new(current_user)
    end
  end

  #def authenticate_inviter!
  #  redirect_to root_path
  #end

  #invitation override
  #def authenticate_resource!
  #  redirect_to root_path
  #end

end
