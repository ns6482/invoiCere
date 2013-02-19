class PaymentsController < BaseController
  include ActiveMerchant::Billing

  before_filter :find_invoice, :only => [:new, :index, :destroy, :delete_multiple]
  before_filter :get_paypal_details, :only => [:create, :complete, :confirm]
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

        @payment.status = 'pending'

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

      elsif params[:payment][:payment_type] == "Paypal"

        if @payment.save

          @amount = ((params[:payment][:amount]).to_f * 100).to_i

          options = {
            :name => "Tickets",
            :quantity => 12,
            :description => "Tickets for test",
            :payment_id => @payment.id,
            #:items => [{:name => "Tickets", :quantity => 22,:description => "Tickets for 232323",  :amount => 10}],
            :ip => request.remote_ip,
            :return_url        => url_for(:action => 'confirm', :only_path => false, :payment_id => @payment.id),
            :cancel_return_url => url_for(:action => 'index', :only_path => false)
          }

          setup_response = gateway.setup_purchase(
          @amount,
          #5000,
          options
          )

          token = setup_response.token
          @payment.update_attribute(:reference, token)
          @payment.update_attribute(:status, "processing")

          #store paypal details token, id , pass id through to get amount
          format.html{redirect_to gateway.redirect_url_for(token)}

        else
          format.html{render :action => 'new'}
          format.js {render :action => 'new'}
        end

      else
      #@payment = Payment.new(params[:payment])
        @payment.status = "paid"
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

  def confirm

    p = Payment.find(params[:payment_id])
    #@reference = p.reference
    #@company_id = p.invoice.client.company_id

    @payment = p if p.invoice.client.company_id == current_company.id and p.reference = params[:token]
    @amount = @payment.amount

    redirect_to :action => 'index' unless params[:token] or @payment.nil?

    details_response = gateway.details_for(params[:token])

    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
    return
    #else
    #payment.update_attributes(:status, "confirmed")
    #create payment entry, with token
    end
    @address = details_response.address

  end

  def complete

    p = Payment.find(params[:payment_id])
    #@reference = p.reference
    #@company_id = p.invoice.client.company_id

    @payment = p if p.invoice.client.company_id == current_company.id and p.reference = params[:token]
    @amount = @payment.amount

    purchase = gateway.purchase(
    (@amount.to_f * 100).to_i,
    :ip       => request.remote_ip,
    :payer_id => params[:payer_id],
    :token    => params[:token]
    )

    p = Payment.find(params[:payment_id])
    #@reference = p.reference
    #@company_id = p.invoice.client.company_id

    @payment = p if p.invoice.client.company_id == current_company.id and p.reference = params[:token]

    redirect_to :action => 'index' unless params[:token] or @payment.nil?

    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
    return
    else
      @payment.status = "paid"
      if @payment.save

      #if @payment.save
        flash[:notice] = "Successfully created payment."
      end
    #format.html{redirect_to @invoice}
    #format.js {render :action => 'create'}
    #else
    # format.html{render :action => 'new'}
    #format.js {render :action => 'new'}
    #end
    end
  end

  def destroy
    # if @payment.invoice.state == "closed"
    #@payment.invoice.open_again!
    #end

    @payment.destroy#(:status, 'cancelled')
    flash[:notice] = "Successfully destroyed payment."
    redirect_to invoice_url(@invoice)
  end


  def delete_multiple

    respond_to do |format|

      i = 0
      #arr_item = Array.new
      #@payments_to_delete = @payments.find(params[:payment_ids])
      @payments_to_delete =Payment.where(:id => params[:payment_ids], :invoice_id => @invoice.id)

      @payments_to_delete.each do |payment|
        #logger.info payment.id
        
        payment.update_attribute(:status, 'cancelled')

      end

      flash[:notice] ='Payments successfully deleted.'
      
      format.html {    redirect_to invoice_url(@invoice)}
      format.js { render :action => 'delete_multiple.js.erb'}
    end

  end


  def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
    @payments = Payment.find_all_by_invoice_id(params[:invoice_id], :include => :user)
  end

  def find_payment
    p = Payment.find(params[:id])
    @payment = p if p.invoice.client.company_id == current_company
  end

  private

  def get_paypal_details
    @paypal_login = current_company.setting.paypal_login
    @paypal_password = current_company.setting.paypal_pwd
    @paypal_signature = current_company.setting.paypal_sig
  end

  def gateway
    ActiveMerchant::Billing::PaypalExpressGateway.default_currency = 'GBP'
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::PaypalExpressGateway.new(
    :login => @paypal_login,
    :password => @paypal_password,
    :signature => @paypal_signature
    #:login => "nehal._1346419619_biz_api1.gmail.com",
    #:password => "1346419698",
    #:signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31APTI85JDJ4J1Y0tTumI1WUPxY4GU"
    )
  end
end
