class PreferencesController < BaseController
  load_and_authorize_resource

  def edit
    @preference = current_company.preference

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