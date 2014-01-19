class DashboardController < BaseController
  layout "dashboard"

  #load_and_authorize_resource :class => "Invoice"
  #load_and_authorize_resource :class => "Client"


  def show
    
    
    summaries_base = current_company.summaries.by_currency.where("yr >= ?", Date.today.year-1)
     
    fiscal_start = current_company.preference.fiscal_start ||=  "0101"    
    fiscal_month = fiscal_start[-2,2].to_i
    fiscal_day = fiscal_start[0,2].to_i
    new_tax_year_date = Date.new(Time.now.year, fiscal_month, fiscal_day)
    
    current_tax_year = Date.today > new_tax_year_date  ?   Date.today.year :  Date.today.year - 1
                     
    @summaries_ytd = summaries_base.to_a.select {|s| s.tax_year = current_tax_year}.group_by {|s | s.currency}
                                     
    @graph_type = params[:type] ||= "invoice"
     
    @start_date = Date.today.at_beginning_of_month >> -11
    @summaries_by_yr_mo = summaries_base.by_yr_mo
    
    
    
    @clients = current_company.summaries.by_client_currency.where("yr >= ?", Date.today.year-1).order("total_amount_closed DESC")

               
    @outstanding = summaries_base.by_client_currency.to_a.group_by {|s | s.currency}
 
    
    
    
      
     # summaries_base = current_company.summaries.where(:tax_year => Time.now.year) #Time.now.year)
     # @summaries = summaries_base.by_currency.to_a.group_by {|s|s.currency}
      
     # @graph_type = params[:type] ||= "invoice"
      
     # @start_date = Date.today.at_beginning_of_month >> -11
     # @summaries_by_yr_mo = summaries_base.by_yr_mo
     # @outstanding = summaries_base.by_client_currency.to_a.group_by {|s | s.currency}
        
  
    respond_to do | format |
      format.html
      format.js 
    end
  end

end

