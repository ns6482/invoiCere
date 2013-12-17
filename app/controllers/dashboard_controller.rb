class DashboardController < BaseController
  layout "dashboard"

  #load_and_authorize_resource :class => "Invoice"
  #load_and_authorize_resource :class => "Client"


  def show
      @summaries_base = current_company.summaries.where(:tax_year =>  Time.now.year)
      @summaries = @summaries_base.by_currency.to_a.group_by {|s|s.currency}
      
      graph_type = params[:graph] ||= "ti"
      
      colors = {:EUR => "Red", :GBP => 'Blue', :USD => 'Green'}
      
      @data = Array.new

      @title = "Total Invoiced YTD"

      @summaries_base.by_yr_mo.to_a.group_by {| s | s.currency }.each do |currency, summaries|
        if graph_type == "ti" 
          @data.push({:data => summaries.map{ | t | {:x => Time.mktime(t.yr,t.mo).to_i, :y => t.total_amount_closed}}, :name => currency, :color => colors[currency.to_sym]})
         else           
          @data.push({:data => summaries.map{ | t | {:x => Time.mktime(t.yr,t.mo).to_i, :y => t.total_payments}}, :name => currency, :color => colors[currency.to_sym]})
          @title = "Total Payments YTD"
         end
      end
      
      @outstanding = @summaries_base.by_client_currency.group_by {|s|s.currency} 
            
      #TODO 
      
     
      #1. add slider, legend to graph above, perhaps bar would look better 
      #2. second summary, list of clients, i, name, total_due, minimum date, due_days (calculated) order by date asc
      #3. add ability to filter out legends
      #4. make graph partial, check queries n+1, perhaps graph controller
  
      #@summaries_time = Hash.new { |h,k| h[k] = Hash.new { |h1,k1| h1[k1] = {}}}
      #current_company.summaries.by_yr_mo.to_a.each do | summary|
      #  @summaries_time[s.currency.to_sym][(s.yr.to_s + " " + s.mo.to_s).to_sym] = {:total_due => s.total_due, :count => s.count_due}
      #end

      #result.keys.each do | currency |
      #  puts currency
       # result[currency].keys.each do | time |
       #    puts time
       #   puts result[currency][time][:total_due]
       # end
      #end
      
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
