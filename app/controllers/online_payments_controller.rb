class OnlinePaymentsController < BaseController
  before_filter :find_invoice, :only => [:new, :index, :destroy]
  load_and_authorize_resource :invoice
  load_and_authorize_resource :payment, :through => :invoice, :shallow => true

  def index 
     respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new
    respond_to do |format|
      if @payment.invoice.remaining_amount ==0.0
        flash[:notice]= "Invoice has been paid for"
        format.html{redirect_to invoice_payments_url(@invoice)}
        format.js {render :action => 'payments/index'}
      elsif @payment.invoice.state=="draft"
        flash[:error]="Cannot pay for draft invoice"
        format.html{redirect_to invoice_url(@invoice)}
        format.js {render :action => 'new'}
      else
        @payment = @invoice.payments.build
        format.html
        format.js
      end
    end
  end
  
  def create
    
    respond_to do |format|
      #@payment = Payment.new(params[:payment])
      @payment.user_id  = current_user.id
        if @payment.save  
          flash[:notice] = "Successfully created payment."
          format.html{redirect_to @invoice}
          format.js {render :action => 'create'}
        else
          format.html{render :action => 'new'}
          format.js {render :action => 'new'}
        end    
       end
    
  end
  
  def destroy
    #@payment = Payment.find(params[:id])
    @payment.invoice.open_again!
    @payment.destroy
    flash[:notice] = "Successfully destroyed payment."
    redirect_to invoice_payments_url(@invoice)
  end

    def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
    @payments = Payment.find_all_by_invoice_id(params[:invoice_id], :include => :user)
  end

  def find_payment
    p = Payment.find(params[:id])
    @payment = p if p.invoice.client.company_id == current_company
  end
end
