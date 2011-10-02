class RemindersController < BaseController
  before_filter :find_invoice  
  load_and_authorize_resource :reminder,:through=> :invoice, :singleton => true
  #load_and_authorize_resource :reminder, :through => :find_invoice, :singleton => true

  load_and_authorize_resource :invoice
  
  def show        
  end
   
  def edit    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def update
    respond_to do |format|
      if !@reminder.update_attributes(params[:reminder])
        format.html {render :action => 'edit'}
        format.js { render :partial => 'reminders/form.html.haml', :status => "500" }
      else

        flash[:notice] = "Successfully updated reminder."
        format.html {redirect_to invoice_url(@invoice) }
        format.js
      end
    end
  end
  
  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
    #@reminder = @invoice.reminder
  end

end
