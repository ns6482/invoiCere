require "open-uri"

class DeliveriesController < BaseController
  before_filter :find_invoice, :only => [:new, :index]
  before_filter :find_delivery, :only => :show
  load_and_authorize_resource :invoice
  load_and_authorize_resource :delivery, :through => :invoice, :shallow => true

  def index 
    #@deliveries = @invoice.deliveries#.paginate :page => params[:page], :per_page => 3
     respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    #@delivery = Delivery.find(params[:id])
  end
  
  def new
    #@invoice = Invoice.find(params[:invoice_id])
    @delivery = @invoice.deliveries.build
    @delivery.client_email  = true
    @delivery.format = 1
    @delivery.message = current_company.etemplate.invoice_message
    
    respond_to do |format|
      format.html
      format.js
    end

 end
  
  def create
    
    respond_to do |format|
      #@delivery = Delivery.new(params[:delivery])
      if @delivery.save

        if @delivery.format ==2
          pdf_file = render_to_string(:action=>'show', :id => @invoice.id, :template=>'invoices/show.pdf.prawn')
          Notifier.deliver_invoice_pdf(@delivery, pdf_file) # sends the email
        elsif @delivery.format ==1
          Notifier.deliver_invoice(@delivery).deliver # sends the email
        end



        flash[:notice] = "Invoice sent successfully"
        format.html {redirect_to invoice_path(@delivery.invoice.id)}
        format.js
      else
        flash[:error] = @delivery.errors.full_messages.join("\n")
        format.html {render :action => 'new'}
        format.js { render :partial => 'deliveries/form.html.haml', :status => "500" }
      end
    end
  end

  def destroy
    #@invoice = Invoice.find(params[:id])
    @delivery.destroy
    notice  "Successfully destroyed delivery."
    redirect_to invoices_url
  end

  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
  end

  def find_delivery   
    d = Delivery.find(params[:id])
    @delivery = d if d.invoice.client.company_id == current_company
  end

end