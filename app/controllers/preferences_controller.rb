class PreferencesController < BaseController
  load_and_authorize_resource

  before_filter :get_preference

  def get_preference
        @preference = current_company.preference
    
    @countries = []
    
    Country.all.each do |d| 
      c= Country.find_country_by_name(d[0])
      if !c.currency.nil?
        @countries << c.name + ", " + c.currency['code'] + " " + c.currency['name']
      end
    end

    t = Time.now
   
    @date_formats = [[t.strftime("%Y %B %d"), "dt0"], [t.strftime("%d %B %Y"), "dt1"], [t.strftime("%B %d %Y"), "dt2"], [t.strftime("%d/%m/%Y"),"dt3"], [t.strftime("%Y-%m-%d"), "dt4"]]
    @time_formats = [["24 Hour", "24"], ["12 Hour", "12"]]
 
  end

  def edit
 
  end

  def update   

    if @preference.update_attributes(params[:preference])
      redirect_to root_url, :notice  => "Successfully updated preferences."
    else
      render :action => "edit"
    end
  end
  
  
end