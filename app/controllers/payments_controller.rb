class PaymentsController < BaseController
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
             
    @payment.user_id  = current_user.id

    if params[:payment][:payment_type] == "GoCardless"
      flash[:notice] = "online"
      
      
        client = GoCardless::Client.new(
          :app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
          :app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
          :token      => current_company.setting.pay_gc_token
        )
      
        
      if @payment.save 
        
        url  = client.new_bill_url :redirect_uri => "https://#{current_company.name}.lvh.me:3000/gocardless/confirm",
          :amount => params[:payment][:amount],
          :name => @invoice.title,
          :user => {
            :first_name => current_user.name,
            :email => current_user.email,
          },
          :state => @payment.id
        
        format.js{redirect_to url}
        format.html{redirect_to url}
      else
          format.html{render :action => 'new'}
          format.js {render :action => 'new'}
        end         
    else     
      #@payment = Payment.new(params[:payment])
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
    
  end
  
  def destroy
    #@payment = Payment.find(params[:id])
    if @payment.invoice.state == "closed"
      @payment.invoice.open_again!
    end
    
    @payment.destroy
    flash[:notice] = "Successfully destroyed payment."
    redirect_to invoice_url(@invoice)
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
