class DashboardController < BaseController

  load_and_authorize_resource :class => "Invoice", :only => "index"
  
  def index
  
      @invoices = current_company.invoices.accessible_by(current_ability)
      @invoices_states = @invoices.group_by {|i| i.formatted_state }
      @date = params[:month] ? Date.parse(params[:month]) : Date.today
        
    respond_to do | format |
      format.html
    end
  end

end
