class SchedulesController < BaseController
  #before_filter :find_invoice, :except => :index
  #before_filter :check_schedule_exists, :only => [:new, :edit]
  load_and_authorize_resource #:schedule,:through=> :invoice, :singleton => true, :except => :index

  def index    
    @schedules = current_company.schedules    
  end
  
  def show    
  end
  
  def new

    @schedule  = Schedule.new
    #@schedule.client_id = params[:client_id]
    @client = current_company.clients.find(params[:client_id])
    @contacts = @client.contacts
    
    @schedule.client = @client
    
    @schedule.schedule_items.build

    
    #@contacts = @invoice.client.contacts
    
    #if Schedule.find_by_invoice_id(@invoice.id)

     # respond_to do |format|
     #   format.html{redirect_to edit_invoice_schedule_url(@invoice)}
     #   format.js{"edit.js"}
     # end
    #else

      respond_to do |format|
        format.html
        format.js
      end
    #end
  end

  def edit
   @schedule = current_company.schedules.find(params[:id])
   @client = @schedule.client
   @contacts = @schedule.client.contacts
   
   respond_to do |format|
    format.html
    format.js
   end
    
  end
  
  def create

    respond_to do |format|
    
    @client = current_company.clients.find( params[:schedule][:client_id])      
    @schedule.client_id =  @client.id 
    @contacts = @client.contacts
    if @schedule.save
      
      #@schedule.save
      flash[:notice] = "Successfully created schedule."
      format.html {redirect_to :action => :index} #{redirect_to invoice_schedule_url(@invoice)}
      format.js
    else
      format.html{render :action => 'new'}
      format.js
    end
    end

  end
      
  def update

    respond_to do |format|
     
      @client = current_company.clients.find(@schedule.client_id)#(params[:schedule][:client_id])
      @schedule.client_id = @client.id
      @contacts = @client.contacts
      
      #if @schedule.valid?
      if @schedule.update_attributes(params[:schedule])
        flash[:notice] = "Successfully updated schedule."
        format.html {redirect_to :action => :index} #{redirect_to invoice_schedule_url(@invoice)}
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
  
  #def find_invoice
   # @invoice = current_company.invoices.find(params[:invoice_id])
  #end

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
