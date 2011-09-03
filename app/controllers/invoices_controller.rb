require "open-uri"
require "prawn"


class InvoicesController < BaseController
  before_filter :get_clients, :only => [:index]
  before_filter :find_invoice, :only => [:show, :edit, :destroy]  
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

    respond_to do | format|
      format.html
      
#      output = @invoice.get_pdf
#      format.pdf do
#        send_data output, :filename => @invoice.title,
#                          :type => "application/pdf"
#      end
     format.pdf
     format.js
      format.xml  { render :xml => @invoice}
    end
    
  end

  #TODO create partial buttons and put into show part, create content for

  def new

    if params[:id]
      master_invoice = current_company.invoices.find(params[:id])
      @invoice = master_invoice.clone_with_associations
      @invoice.invoice_date=Date.today
    else
      @invoice.invoice_date=Date.today
      @invoice.invoice_items.build
    end

    #@invoice = Invoice.new(:invoice_date => Date.today)
    
  end
  
  def create
     
    #@invoice = Invoice.new(params[:invoice])
    #authorize! :create, @invoice

    if  current_company.clients.exists?(@invoice.client)
      if @invoice.save
        notice  "Successfully created invoice."
        redirect_to @invoice
      else
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
      @invoice.update_user = current_user.email
      #@invoice = Invoice.find(params[:id])
      if params[:commit] == "complete"
        @invoice.complete!
        notice  "Invoice is now open and ready for payment"
        format.html {redirect_to @invoice}
        format.js
      elsif params[:commit] == "pay"
        @invoice.pay!
        notice  "Invoice marked as paid"
        format.html{redirect_to @invoice}
        format.js
      else
        if @invoice.update_attributes(params[:invoice])
          notice "Successfully updated invoice."
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
    notice  "Successfully destroyed invoice."
    redirect_to invoices_url
  end


  private




  def find_invoice
    @invoice = current_company.invoices.find(params[:id])
    @invoice.invoice_items.count
  end

  def get_clients
    #authorize! :read, current_company
    @clients = current_company.clients.accessible_by(current_ability)#.accessible_by(current_ability, :read)
    @invoices = current_company.invoices.none_scheduled.accessible_by(current_ability)

    #@invoices = current_company.invoices.accessible_by(current_ability).find(:all)
    #.accessible_by(current_ability, :read)
    ##clients.collect { |c| c.invoices }.flatten # select all invoices for all clients of the firm
    #@invoices = Invoice.find(:all, :joins => :client, :conditions => ["clients.company_id = ?", current_company.id])
  end
  
end
