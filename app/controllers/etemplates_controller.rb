class EtemplatesController < BaseController
  load_and_authorize_resource
  
  def edit
    @etemplate = current_company.etemplate
  end
  
  def update
    @etemplate = current_company.etemplate

    if @etemplate.update_attributes(params[:etemplate])
      flash[:notice] = "Successfully updated templates."
      redirect_to root_path
    else        
      render :template => "etemplates/edit.html"
    end
  end
  
  private
  
end

