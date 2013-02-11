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
       format.csv {

          items = CSV.generate do |csv|
            csv << ["id", "business id", "created at", "invoice date", "title", "notes", "tax rate", "delivery_charge", "purchase order id", "status", "late fee", "due days", "total cost", "total cost including delivery and tax", "due date", "opened date", "opened_by", "paid date", "paid by", "cancelled", "cancelled date", "cancelled by", "discount", "currency", "item id", "item description", "item quantity", "item cost", "item taxable", "item created at"]
            @invoices.each do |inv|
              csv << [inv.id, inv.business_id, inv.created_at, inv.invoice_date, inv.title, inv.notes, inv.tax_rate, inv.delivery_charge, inv.purchase_order_id, inv.state, inv.late_fee, inv.due_days, inv.total_cost, inv.total_cost_inc_tax_delivery, inv.due_date,  inv.opened_date, inv.opened_by, inv.paid_date, inv.paid_by, inv.cancelled, inv.cancelled_date, inv.cancelled_by, inv.discount, inv.currency, inv.invoice_items.first.id, inv.invoice_items.first.item_description, inv.invoice_items.first.qty, inv.invoice_items.first.cost, inv.invoice_items.first.taxable, inv.invoice_items.first.created_at]
              if inv.invoice_items.count > 1
                counter = 0
                inv.invoice_items.each do |item|
                  if counter != 0 then 
                    csv << ["","","","","","","","","","","","","","","","","","","","","","", "", "",item.id, item.item_description, item.qty, item.cost, item.taxable, item.created_at]
                  end 
                  counter +=1
                end
              end
            end
          end
           
          send_data items

        }

    end
  end
  
  def show


    output = InvoiceReport.new(@invoice).to_pdf


    @time = Time.now
    
    respond_to do | format|
     format.html
     #format.pdf
     format.pdf do
        send_data output, :filename => current_company.name + "_" + @invoice.title + "_" + @invoice.id.to_s, 
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
    
        @time = Time.now

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
