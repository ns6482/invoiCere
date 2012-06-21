class GocardlessController < BaseController
  
  force_ssl  
    
  def index
  end
  
  def submit
    # We'll be billing everyone Â£10 per month for a premium subscription
    url_params = {
     :amount => 10,
     :interval_unit => "month",
     :interval_length => 1,
     :name => "Premium Subscription",
     # Set the user email from the submitted value
     :user => {
      :email => params["email"]
     }
    }
    
    url = GoCardless.new_subscription_url(url_params)
    redirect_to url
  end
  
   # Implement the confirm path
  def confirm
    begin
      GoCardless.confirm_resource params
      render "gocardless/success"
    rescue GoCardless::ApiError => e
      @error = e
      render :text => "Could not confirm new subscription. Details: #{e}"
    end
  end
  
  def setup_merchant

    c = GoCardless::Client.new(
      :app_id     => 'sHS9jFQyQ_CsNnSpTVQ_2KEpYPYNEBreEUCw4bmosgPvTX05pDk7X9dXiBnLJ6mF',
      :app_secret => 'B6l03urndX7H0Q6yQ16_ByjnGgHZWNqqzpM9RquXxvHPf5SOxbJomjeq1P8Gvz2R',
    )
    
    url = c.new_merchant_url(:redirect_uri => 'http://lvh.me:3000/gocardless/cb')

    redirect_to url
  end
  
  def cb
    auth_code = params[:code]
    
    #c.fetch_access_token(auth_code, :redirect_uri => 'http://foo.lvh.me:3000/gocardless/cb')
    
    #c.access_token
    #current_company.setting.update_attribute(:pay_gc_token, c.access_token)
    
    #c.merchant 
    
    render :index
  end
  
end

