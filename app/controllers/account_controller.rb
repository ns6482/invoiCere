class BaseController < ApplicationController

  layout "dashboard"
#  before_filter :company_required
##  before_filter :authenticate_user! or :authenticate_account!
#  before_filter :check_logged_in

#  def check_logged_in
#    unless user_signed_in? or account_signed_in?
#      authenticate_user!
#    end
#  end

end
