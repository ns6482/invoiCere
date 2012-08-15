class GocardlessController < ApplicationController
  
  
  layout "dashboard"
  before_filter :company_required
  #force_ssl  
  before_filter :find_invoice, :only => [:new]

    
  
  def new
     render :text => @invoice.id
  end
  
  
   # Implement the confirm path
  def confirm  
    begin
      client = GoCardless::Client.new(
        :app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
        :app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
        :token      =>  current_company.setting.pay_gc_token,
      )
      
      client.confirm_resource params
      
      @resource_id = params[:resource_id]
      payment_id = params[:state]
      
      @payment = current_company.payments.find(payment_id)
      @payment.update_attribute(:reference, @resource_id)
      
      
      flash[:notice] = "Payment to GoCardless sucessfully made"
      redirect_to invoice_path(@payment.invoice_id)
      
      #render "gocardless/success"
    rescue GoCardless::ApiError => e
      @error = e
      flash[:notice] =  "Could not confirm new bill. Details: #{e}"
    end
  end
  
  def setup_merchant

    c = GoCardless::Client.new(
      :app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
      :app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
    )
    
    #c = GoCardless::Client.new
    url = c.new_merchant_url(:redirect_uri => "https://#{current_company.name}.lvh.me:3000/gocardless/cb", :cancel_uri => "https://#{current_company.name}.lvh.me:3000/company/edit", :merchant => {:billing_postcode => "CV11 4TB",  :user => {:email => "soni.isha1@gmail.com", :first_name => "Isha", :last_name => "Soni"}},  :scope => "manage_merchant", :response_type => "code")

    redirect_to url
  end
  
  def cb
    auth_code = params[:code]
    
    c = GoCardless::Client.new(
      :app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
      :app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
    )
    
    c.fetch_access_token(auth_code, :redirect_uri => "https://#{current_company.name}.lvh.me:3000/gocardless/cb")
    
    #c.access_token

    current_company.setting.update_attribute(:pay_gc_token, c.access_token)
    
    
    #c2 = GoCardless::Client.new(
  #:app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
  #:app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
  #:token      => c.access_token,
  #)


    
    #render :text =>  c2.merchant.id

    redirect_to edit_company_path
    #render :index
  end
  
   def find_invoice
    @invoice = current_company.invoices.find(params[:invoice_id])
    @payments = Payment.find_all_by_invoice_id(params[:invoice_id], :include => :user)
  end
  
  def webhook
  
  
   client = GoCardless::Client.new(
        :app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
        :app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
        #:token      =>  '69XDW8XYNW97EQKZK0D4VTRQFEBDWQ7S9DTWHFT5PPA1PV726J3NVQHZ0KJDNY16 manage_merchant:04NVAHP1BT',
    )

    if client.webhook_valid?(params[:payload])
      data = params[:payload]
      
      if data[:resource_type] == "bill" && data[:action] == "paid"
        data[:bills].each do |bill|
          # Lookup the subscription using subscription[:resource_id]
          # Perform logic to cancel the subscription
          # Any time-consuming jobs should be performed asynchronously
          ##payment = Payment.find_by_reference(bill[:resource_id])
          payment = Payment.find_by_reference("054MMY12C0")
          payment.update_attribute(:status, "paid")
          
          #Rails.log "Bill #{bill[:resource_id]} paid"         
          #render :text => "true", :status => 200
        end
      end
      render :text => "true", :status => 200
    else
      render :text => "failed webhook", :status => 403
    end
  end


  
end

