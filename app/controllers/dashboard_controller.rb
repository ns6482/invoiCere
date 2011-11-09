class DashboardController < BaseController

  load_and_authorize_resource :class => "Invoice", :only => "index"
  
  def index
  
      @invoices = current_company.invoices.accessible_by(current_ability)
      @invoices_states = @invoices.group_by {|i| i.formatted_state }
      
      #@date = params[:month] ? Date.parse(params[:month]) : Date.today
      @date = (params[:month] and params[:year]) ? Date.strptime("#{params[:month]} #{params[:year]}", '%m %Y') : Date.today
      
      
      @invoices_for_year = @invoices.find_all{|item| item.invoice_date.year == @date.year }
      @invoices_for_month = @invoices_for_year.find_all{|item| item.invoice_date.month == @date.month }
      
      @total_invoice = @invoices.find_all{|item| item.invoice_date.year == @date.year}.collect {|item_total| item_total.total_cost_inc_tax_delivery}.reduce(:+)  
    
      @invoices_year_breakdown = @invoices_for_year.group_by{|invoice| invoice.invoice_date.month} 
      @invoices_month_breakdown = @invoices_for_month.group_by{|invoice| invoice.invoice_date.day} 

    respond_to do | format |
      format.html
    end
  end

end
