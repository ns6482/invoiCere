class DashboardController < BaseController
  layout "dashboard"

  #load_and_authorize_resource :class => "Invoice"
  #load_and_authorize_resource :class => "Client"
  
  def show
  
      @invoices = current_company.invoices.accessible_by(current_ability).where(:type=> 'StandardInvoice')
      @invoice_paid = @invoices.joins("JOIN payments ON payments.invoice_id = invoices.id").uniq

      @invoices_states = @invoice_paid.open.group_by {|i| i.formatted_state }
      
      @date = (params[:month] and params[:year]) ? Date.strptime("#{params[:month]} #{params[:year]}", '%m %Y') : Date.today

      @invoices_for_year = @invoices.ytd.open.accessible_by(current_ability)
      @invoices_for_month = @invoices_for_year.find_all{|item| item.invoice_date.month == @date.month }

      #TODO - total_invoiced where status is open only - total paid  maybe...check
      @total_invoice = @invoices.ytd.open.sum(:total_cost_inc_tax_delivery)#@invoices_for_year.collect {|item_total| item_total.total_cost_inc_tax_delivery}.reduce(:+)  
      @total_paid = @invoice_paid.open.sum("payments.amount")
      @total_outstanding = @total_invoice.to_i - @total_paid.to_i
      
      @clients_outstanding = current_company.clients.outstanding.accessible_by(current_ability)
 
      if params[:gdate]
        @gdate = params[:gdate]
      else
        @gdate =1 
      end
  
    respond_to do | format |
      format.html
      format.js
    end
  end

end
