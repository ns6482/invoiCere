require "open-uri"
require 'prawn'
require 'prawn/core'
require 'prawn/layout'

class InvoicesController < BaseController
  before_filter :get_invoices, :only => [:index, :edit]
  before_filter :get_clients , :except =>[:index, :show]
  before_filter :find_invoice, :only => [:show, :edit, :destroy, :update, :revert_draft, :open, :reopen, :pay]
  #before_filter :get_countries, :only => [:edit, :new]
  before_filter :get_currencies, :only => [:edit, :new]
  before_filter :set_user, :only => [:create, :update, :revert_draft, :open, :reopen, :pay]

  skip_before_filter :check_logged_in, :only => [:show]

  #load_and_authorize_resource :except => [:show]
  def index
    authorize! :read, StandardInvoice

    @search = @invoices.search(params[:search])

    #@invoices = @search.all
    @invoices = @search.paginate :page => params[:page], :per_page => 10

    #@invoices = Invoice.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.js
      format.csv { send_data Invoice.to_csv(@invoices)}

    end
  end

  def show
    authorize! :read, @invoice
    
    @style = params[:style]
   
    @curr = @invoice.currency
    @dae = false
    @time = Time.now

    @delivery = Delivery.new

    respond_to do | format|
      format.html
      #format.pdf
      format.pdf do

        logo_url = current_company.setting.logo.url
        output = InvoiceReport.new(@invoice, logo_url).to_pdf

        send_data output, :filename => current_company.name + "_" + @invoice.title + "_" + @invoice.id.to_s,
                          :type => "application/pdf"
      end

      format.js
      format.xml  { render :xml => @invoice}
    end

  end

  #TODO create partial buttons and put into show part, create content for

  def new
  
    @invoice = StandardInvoice.new 
    authorize! :create, @invoice
    
    @invoice.currency = current_company.preference.currency_format

    if params[:client_id]
      @invoice.client_id = params[:client_id]
    end

    if params[:id]
      master_invoice = current_company.invoices.find(params[:id], :conditions => {:type => 'StandardInvoice'})
      @invoice  = master_invoice.dup :include => :invoice_items
      @invoice.state = "draft"
      @invoice.invoice_date=Date.today

    #      @invoice.invoice_items << InvoiceItem.new(:type=> "test", :description => "gg")
    else
      @invoice.invoice_date=Date.today

      #3.times do
      @invoice.invoice_items.build
      #end

      if current_company.preference.discount.size >0
        @invoice.discount  = current_company.preference.discount
      end

      if current_company.preference.shipping.size > 0
        @invoice.delivery_charge = current_company.preference.discount
      end

      if current_company.setting.vat.size > 0
        @invoice.tax_rate = current_company.setting.vat
      end

    end

  #@invoice = Invoice.new(:invoice_date => Date.today)

  end

  def create
    
   # @clients = current_company.clients.accessible_by(current_ability)#.accessible_by(current_ability, :read)


    @invoice = StandardInvoice.new(params[:invoice])
    authorize! :create, @invoice

    if  current_company.clients.exists?(@invoice.client)
      if @invoice.save
        flash[:notice] =   "Successfully created invoice."
        track_activity @invoice
        redirect_to @invoice
      else
        flash[:error] = "Please make sure fields are completed correctly"
        render :action => 'new'
      end
    else
      flash[:error] = "You must select a client"
      render :action => 'new'
    end
  end

  def edit
    #todo
    #redirect if draft status

    #@invoice = Invoice.find(params[:id])
    authorize! :create, @invoice
  end
  
  def revert_draft
    @invoice.revert_draft!
    refresh_after_status_update "Invoice is in draft status", "changed back to draft"
  end
  
  def open
    @invoice.open!
    refresh_after_status_update "Invoice is now open and ready for payment", "made open"
  end
  
  def reopen
    @invoice.open_again!
    refresh_after_status_update "Invoice is now open and ready for payment", "reopened from draft"
  end
  
  def pay
    @invoice.pay!
    refresh_after_status_update "Invoice marked as paid", "paid"
  end
  
  
  def update

    @time = Time.now

    #todo
    #redirect if draft status

    respond_to do |format|
     
        if @invoice.update_attributes(params[:invoice])  
          refresh_after_status_update "Successfully updated invoice."
        else
          flash[:error] = "Please make sure fields are completed correctly"
          format.html {render :action => 'edit'}
          format.js { render :action => 'edit'}
        end
      end
  
  end

  def destroy
    #@invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:notice] =   "Successfully destroyed invoice."
    redirect_to invoices_url
  end

  def delete_multiple

    respond_to do |format|

      authorize! :delete, Invoice
    
      i = 0
      #arr_item = Array.new
      @invoices_to_delete = current_company.invoices.find(params[:invoice_ids], :conditions => {:type => 'StandardInvoice'})
      @invoices_to_delete.each do |invoice|
      invoice.destroy
      end

      flash[:notice] ='Invoices successfully deleted.'
      format.html {redirect_to invoices_url}
      format.js { render :action => 'delete_multiple.js.erb'}
    end

  end

  private

  def find_invoice
    if user_signed_in?
      @invoice = current_company.invoices.find(params[:id], :conditions => {:type => 'StandardInvoice'})
      authorize! :show, @invoice
     else
        @invoice = current_company.standard_invoices.find_by_secret_id(params[:id])
     end
     
     if @invoice       
        @invoice.invoice_items.count
      else
        raise ActionController::RoutingError.new('Not Found')
      end
  end


  def get_clients
    
        @clients = current_company.clients.accessible_by(current_ability)#.accessible_by(current_ability, :read)    
  end
  
  def get_invoices
    #authorize! :read, current_company
    #@clients = current_company.clients.accessible_by(current_ability)#.accessible_by(current_ability, :read)
    @invoices = current_company.invoices.accessible_by(current_ability).where(:type => 'StandardInvoice')

  

  #@invoices = current_company.invoices.accessible_by(current_ability).find(:all)
  #.accessible_by(current_ability, :read)
  ##clients.collect { |c| c.invoices }.flatten # select all invoices for all clients of the firm
  #@invoices = Invoice.find(:all, :joins => :client, :conditions => ["clients.company_id = ?", current_company.id])
  end

  def get_countries
    @countries = []

    Country.all.each do |d|
      c= Country.find_country_by_name(d[0])
      if !c.currency.nil?
        @countries << c.name + ", " + c.currency['code'] + " " + c.currency['name']
      end
    end

  end

  def get_currencies
    @currencies = all_currencies(Money::Currency.table)
  end
  
  def set_user
    @invoice.user =  current_user
  end
  
  def refresh_after_status_update(message, action = params[:action])
      respond_to do |format|
        track_activity @invoice, action        
        format.html {redirect_to @invoice}
        format.js { render :action => 'update.js.erb'}
      end
      
      flash[:notice] =  message
      
  end

end
