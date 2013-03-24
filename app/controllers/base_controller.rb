class BaseController < ApplicationController

  layout "dashboard"
  before_filter :company_required
##  before_filter :authenticate_user! or :authenticate_account!
  before_filter :check_logged_in

  before_filter :set_timezone
 
 

   def set_timezone
   
    Time.zone  = current_user.company.preference.time_zone if user_signed_in?
   
   end


  def check_logged_in
    unless user_signed_in? #or account_signed_in?
      authenticate_user!
    end
  end
  
  # Returns an array of all currency id
  def all_currencies(hash)
  hash.inject([]) do |array, (id, attributes)|
      priority = attributes[:priority]
      if priority && priority < 40
        array[priority] ||= []
        array[priority] << id.to_currency
      end
      array
  end.compact.flatten
  end


end
