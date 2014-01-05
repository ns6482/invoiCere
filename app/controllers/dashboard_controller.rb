class DashboardController < BaseController
  layout "dashboard"

  #load_and_authorize_resource :class => "Invoice"
  #load_and_authorize_resource :class => "Client"


  def show
      summaries_base = current_company.summaries.where(:tax_year => 2013) #Time.now.year)
      @summaries = summaries_base.by_currency.to_a.group_by {|s|s.currency}
      
      @graph_type = params[:type] ||= "invoice"
      
      @start_date = Date.today.at_beginning_of_month >> -11
      @summaries_by_yr_mo = summaries_base.by_yr_mo
      @outstanding = summaries_base.by_client_currency.to_a.group_by {|s | s.currency}
      
      #all_clients.each do |currency, clients|
        #@data2.push({:data => clients.map{ | c | {:x => c.client_id, :y=> c.total_amount_closed}}, :name => currency, :color => colors[currency.to_sym]})
      #end      
  
    respond_to do | format |
      format.html
      format.js 
    end
  end

end

