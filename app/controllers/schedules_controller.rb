class SchedulesController < BaseController
  before_filter :find_invoice, :except => :index
  #before_filter :check_schedule_exists, :only => [:new, :edit]
  load_and_authorize_resource :schedule,:through=> :invoice, :singleton => true, :except => :index

  def index    
    @schedules = current_company.schedules    
  end
  
  def show    
  end
  
  def new

    if Schedule.find_by_invoice_id(@invoice.id)

      respond_to do |format|
        format.html{redirect_to edit_invoice_schedule_url(@invoice)}
        format.js{"edit.js"}
      end
    else


      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def edit

    if !Schedule.find_by_invoice_id(@invoice.id)

      respond_to do |format|
        format.html{redirect_to new_invoice_schedule_url(@invoice)}
        format.js{"edit.js"}
      end
    else
      
      user ||= User.new

      respond_to do |format|
        format.html
        format.js
      end
    end
  end
  
  def create

    respond_to do |format|
    if @schedule.valid?
      @schedule.save
      flash[:notice] = "Successfully created schedule."
      format.html {redirect_to invoice_schedule_url(@invoice)}
      format.js
    else
      format.html{render :action => 'new'}
      format.js
    end
    end

  end
      
  def update

    respond_to do |format|
      if @schedule.valid?
        @schedule.update_attributes(params[:schedule])
        flash[:notice] = "Successfully updated schedule."
        format.html {redirect_to invoice_schedule_url(@schedule.invoice)}
        format.js
      else
        format.html{render :action => 'edit'}
        format.js
      end
    end
  end
  
  def destroy    
    @schedule.destroy
    flash[:notice] = "Successfully destroyed schedule."
    redirect_to schedules_url
  end

  private
  
  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
  end

   def check_schedule_exists
      if Schedule.find_by_invoice_id(@invoice.id)
  
        respond_to do |format|
          format.html{redirect_to edit_invoice_schedule_url(@invoice)}
          format.js{"edit.js"}
        end
      else
        respond_to do |format|
          format.html{redirect_to new_invoice_schedule_url(@invoice)}
          format.js{"new.js"}
      end
      end
   end
end
