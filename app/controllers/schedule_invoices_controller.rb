require "ReoccuringInvoice"

class ScheduleInvoicesController < BaseController
  before_filter :get_clients,  :only => [:new, :edit]

  def index  
    authorize! :read, ScheduleInvoice  
    @schedules = current_company.invoices.where(:type => 'ScheduleInvoice')    
  end

  def show   

    @schedule = current_company.invoices.find(params[:id], :conditions => {:type => 'ScheduleInvoice'})
    authorize! :read, @schedule

    @invoices = current_company.invoices.where(:type => 'StandardInvoice', :seed_schedule_id => params[:id])

    @curr = @schedule.currency
    @dae = false
    @time = Time.now

  end

  def new
    if params[:invoice_id]  
      master_invoice = current_company.invoices.find(params[:invoice_id], :conditions => {:type => 'StandardInvoice'})
      @schedule_invoice  = master_invoice.dup :include => [:invoice_items, :client]
      @schedule_invoice.becomes(ScheduleInvoice)
    else
      @schedule_invoice  = ScheduleInvoice.new
      @schedule_invoice.invoice_items.build
      @schedule_invoice.currency = current_company.preference.currency_format
      @schedule_invoice.tax_rate = current_company.preference.tax
    end

    authorize! :create, @schedule_invoice

    @schedule_invoice.custom_message = current_company.etemplate.invoice_message
    @schedule_invoice.state = "draft"
    @client = @schedule_invoice.client ||= current_company.clients.first  
    
    respond_to do |format|
      format.html
      format.js
    end

  end

  def edit

    @schedule = current_company.invoices.find(params[:id], :conditions => {:type => 'ScheduleInvoice'})
    authorize! :update, @schedule

    @client = @schedule.client

    respond_to do |format|
      format.html
      format.js
    end

  end

  def create

    @schedule = ScheduleInvoice.new(params[:invoice])

    authorize! :create, @schedule

    respond_to do |format|

      @schedule.base_request = "#{request.protocol}#{request.host_with_port}"
      if @schedule.save
        flash[:notice] = "Successfully created schedule."
        format.html {redirect_to :action => :index} #{redirect_to invoice_schedule_url(@invoice)}
        format.js
      else
        format.html{render :action => 'new'}
        format.js
      end
    end
    #end
  end

  def update

    respond_to do |format|

      @schedule = current_company.invoices.find(params[:id], :conditions => {:type => 'ScheduleInvoice'})
      authorize! :update, @schedule

      @client = current_company.clients.find(@schedule.client_id)
      @schedule.client_id = @client.id
      @contacts = @client.contacts

      if @schedule.update_attributes(params[:invoice])
        flash[:notice] = "Successfully updated schedule."
        format.html {redirect_to schedule_path(@schedule)}
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

  def delete_multiple

    respond_to do |format|

      authorize! :delete, ScheduleInvoice

      @schedules_to_delete = current_company.invoices.find(params[:invoice_ids], :conditions => {:type => 'ScheduleInvoice'})
      @schedules_to_delete.each do |schedule|
        schedule.destroy
      end

      flash[:notice] ='Reoccuring invoices successfully deleted.'
      format.html {redirect_to invoices_url}
      format.js { render :action => 'delete_multiple.js.erb'}
    end

  end

  private

  def get_currencies
    @currencies = all_currencies(Money::Currency.table)
  end

  def get_clients
    @clients = current_company.clients.accessible_by(current_ability)
  end



end
