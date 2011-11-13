class DashboardController < BaseController

  load_and_authorize_resource :class => "Invoice", :only => "index"
  
  def index
  
      @invoices = current_company.invoices.accessible_by(current_ability).includes(:payments)
      
      @invoices_states = @invoices.group_by {|i| i.formatted_state }
      

      @date = (params[:month] and params[:year]) ? Date.strptime("#{params[:month]} #{params[:year]}", '%m %Y') : Date.today


      @invoices_for_year = @invoices.ytd.accessible_by(current_ability)
      @invoices_for_month = @invoices_for_year.find_all{|item| item.invoice_date.month == @date.month }

      @total_invoice = @invoices.ytd.sum(:total_cost_inc_tax_delivery)#@invoices_for_year.collect {|item_total| item_total.total_cost_inc_tax_delivery}.reduce(:+)  
      @total_paid = @invoices.sum("payments.amount")
      @total_outstanding = @total_invoice.to_i - @total_paid.to_i
      
      
      @invoices_year_breakdown = @invoices.ytd.group_by_month
      @invoices_month_breakdown = @invoices.mtd.group_by_day
      
      @graph = @invoices.last_12_months
      

    respond_to do | format |
      format.html
    end
  end

end
