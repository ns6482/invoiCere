class DashboardController < BaseController

  load_and_authorize_resource :class => "Invoice", :only => "index"
  
  def index
  
      @invoices = current_company.invoices.accessible_by(current_ability)
      @invoices_states = @invoices.group_by {|i| i.formatted_state }
      
      #@date = params[:month] ? Date.parse(params[:month]) : Date.today
      @date = (params[:month] and params[:year]) ? Date.strptime("#{params[:month]} #{params[:year]}", '%m %Y') : Date.today
      @invoices_for_month = @invoices.find_all{|item| item.invoice_date.month == @date.month and item.invoice_date.year == @date.year }
      
      @total_invoice = @invoices.find_all{|item| item.invoice_date.year == @date.year}.collect {|item_total| item_total.total_cost_inc_tax_delivery}.reduce(:+)  
    
      @invoices_month = current_company.invoices.accessible_by(current_ability).group_by{|invoice| invoice.invoice_date.month} 

    respond_to do | format |
      format.html
    end
  end

end
