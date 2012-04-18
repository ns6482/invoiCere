require "open-uri"
require 'prawn'
require 'prawn/core'
require 'prawn/layout' 


class InvoicesController < BaseController
  before_filter :get_clients, :only => [:index, :new, :edit]
  before_filter :find_invoice, :only => [:show, :edit, :destroy, :update]  
  before_filter :get_countries, :only => [:edit, :new]
  
  load_and_authorize_resource

  def index
    @search = @invoices.search(params[:search])
   
    #@invoices = @search.all
    @invoices = @search.paginate :page => params[:page], :per_page => 10
   
    #@invoices = Invoice.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
      format.js
    end
  end
  
  def show


    output = InvoiceReport.new(@invoice).to_pdf

    respond_to do | format|
     format.html
     #format.pdf
     format.pdf do
        send_data output, :filename => "hello.pdf", 
                          :type => "application/pdf"
     end

     format.js
     format.xml  { render :xml => @invoice}
    end
    
  end

  #TODO create partial buttons and put into show part, create content for

  def new
    
    
    if params[:client_id] 
      @invoice.client_id = params[:client_id] 
    end

    if params[:id]    
      master_invoice = current_company.invoices.find(params[:id])
      @invoice  = master_invoice.clone :include => :invoice_items
      @invoice.state = "draft"
      @invoice.invoice_date=Date.today
      
#      @invoice.invoice_items << InvoiceItem.new(:type=> "test", :description => "gg")
    else
      @invoice.invoice_date=Date.today
      
      #3.times do
       @invoice.invoice_items.build
      #end

    end

    #@invoice = Invoice.new(:invoice_date => Date.today)
    
  end
  
  def create
     
    #@invoice = Invoice.new(params[:invoice])
    #authorize! :create, @invoice

    if  current_company.clients.exists?(@invoice.client)
      if @invoice.save
        flash[:notice] =   "Successfully created invoice."
        redirect_to @invoice
      else
        flash[:notice] = "Please make sure fields are completed correctly"
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
    #todo
    #redirect if draft status

    #@invoice = Invoice.find(params[:id])
    #authorize! :update, @invoice   
  end
  
  def update
    #todo
    #redirect if draft status
    
    respond_to do |format|
      #@invoice.read_only => false
      @invoice.update_user = current_user.email
      #@invoice = Invoice.find(params[:id])
      if params[:commit] == "revert_draft"
        @invoice.revert_draft!
        flash[:notice] =  "Invoice is in draft status"
        format.html {redirect_to @invoice}
        format.js
      elsif params[:commit] == "open" 
        @invoice.open!
        flash[:notice] =  "Invoice is now open and ready for payment"
        format.html {redirect_to @invoice}
        format.js
    elsif params[:commit] == "open_again" 
        @invoice.open_again!
        flash[:notice] =  "Invoice is now open and ready for payment"
        format.html {redirect_to @invoice}
        format.js
      elsif params[:commit] == "pay"
        @invoice.pay!
        flash[:notice] = "Invoice marked as paid"
        format.html{redirect_to @invoice}
        format.js   
      else
        if @invoice.update_attributes(params[:invoice])
          flash[:notice] =  "Successfully updated invoice."
          format.html{redirect_to @invoice}
          format.js 
        else
          flash[:error] = @invoice.errors.full_messages.join("\n")
          format.html {render :action => 'edit'}
          format.js { render :action => 'edit'}
        end
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
         
    i = 0
    #arr_item = Array.new
    @invoices_to_delete = @invoices.find(params[:invoice_ids])
    @invoices_to_delete.each do |invoice|
      #invoice.destroy 
    end

    flash[:notice] ='Invoices successfully deleted.'
    format.html {redirect_to invoices_url}  
    format.js { render :action => 'delete_multiple.js.erb'}
  end
  
 end

  private

  def find_invoice
    @invoice = current_company.invoices.find(params[:id])
    @invoice.invoice_items.count
  end

  def get_clients
    #authorize! :read, current_company
    @clients = current_company.clients.accessible_by(current_ability)#.accessible_by(current_ability, :read)
    @invoices = current_company.invoices.accessible_by(current_ability)

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
  
end
