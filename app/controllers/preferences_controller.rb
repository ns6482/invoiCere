class PreferencesController < ApplicationController
  def edit
    @preferences = Preferences.find(params[:id])
  end

  def update
    @preferences = Preferences.find(params[:id])
    if @preferences.update_attributes(params[:preferences])
      redirect_to root_url, :notice  => "Successfully updated preferences."
    else
      render :action => 'edit'
    end
  end
end
