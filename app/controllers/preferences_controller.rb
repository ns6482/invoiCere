class PreferencesController < BaseController
  load_and_authorize_resource

  def edit
    @preference = current_company.preference
    
    t = Time.now
   
    @date_formats = [[t.strftime("%Y %B %d"), "dt0"], [t.strftime("%d %B %Y"), "dt1"], [t.strftime("%B %d %Y"), "dt2"], [t.strftime("%d/%m/%Y"),"dt3"], [t.strftime("%Y-%m-%d"), "dt4"]]
    

  end

  def update
     @preference = current_company.preferences
     
    if @preference.update_attributes(params[:preferences])
      redirect_to root_url, :notice  => "Successfully updated preferences."
    else
      render :template => "preferences/edit.html"
    end
  end
  
  
end