require "open-uri"
require "DeliveryMailer"

class DeliveriesController < BaseController
  before_filter :find_invoice, :only => [:new, :index, :delete_multiple]
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
    
    
    template =params[:template]
    #logger.debug "template " + template    
    #@invoice = Invoice.find(params[:invoice_id])
    @delivery = @invoice.deliveries.build
    @delivery.client_email  = true
    @delivery.format = 1
    
    if template == 'invoice' then  
      @delivery.message = current_company.etemplate.invoice_message
     else
      @delivery.message = current_company.etemplate.reminder_message
      end

      
    
    
    respond_to do |format|
      format.html
      format.js {render :action => '../shared/modal/new'}
    end

 end
  
  def create
    
    respond_to do |format|
      
     
      
      #@delivery = Delivery.new(params[:delivery])
      if @delivery.save

        base = "#{request.protocol}#{request.host_with_port}"
         
        Resque.enqueue(DeliveryMailer, @delivery.id, "#{request.protocol}#{request.host_with_port}")


      # if @delivery.format ==2
                

#          pdf_file = render_to_string(:action=>'show', :id => @invoice.id, :template=>'invoices/show.pdf.prawn')
    #      Notifier.invoice_pdf(@delivery, base, "#{base}/invoices/#{@delivery.invoice.secret_id}").deliver # sends the email
#        elsif @delivery.format ==1
#                    
#          base = "#{request.protocol}#{request.host_with_port}"
#          Notifier.invoice(@delivery, base, "#{base}/invoices/#{@delivery.invoice.secret_id}").deliver # sends the email
 #       end

        flash[:notice] = "Invoice sent successfully"
        format.html {redirect_to invoice_path(@delivery.invoice.id)}
        format.js{render :action => '../shared/modal/create'}
      else
        flash[:error] = @delivery.errors.full_messages.join("\n")
        format.html {render :action => 'new'}
        format.js {render :action => '../shared/modal/new'}
      end
    end
  end

  def destroy
    #@invoice = Invoice.find(params[:id])
    @delivery.destroy
    notice  "Successfully destroyed delivery."
    redirect_to invoices_url
  end
  
   def delete_multiple

    respond_to do |format|

      i = 0
      #arr_item = Array.new
      #@payments_to_delete = @payments.find(params[:payment_ids])
      @deliveries_to_delete =Delivery.where(:id => params[:delivery_ids], :invoice_id => @invoice.id)

      @deliveries_to_delete.each do |delivery|
        #logger.info payment.id
        delivery.destroy
      end

      flash[:notice] ='Message successfully deleted.'
      
      format.html {    redirect_to invoice_url(@invoice)}
      format.js { render :action => 'delete_multiple.js.erb'}
    end

  end
  

  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
  end

  def find_delivery   
    d = Delivery.find(params[:id])
    @delivery = d if d.invoice.client.company_id == current_company
  end
  
 

end
