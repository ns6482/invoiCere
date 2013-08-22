class PlansController < BaseController

  #before_filter :company_required
  
  def index
    
    @plans = Plan.order(:price)
    
  end

end
