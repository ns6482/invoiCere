class SubscriptionsController < BaseController

  before_filter  :get_plan, :only => [:edit, :update]
  before_filter  :get_plan_new, :only => [:new ]
  def get_plan_new
    if current_company.subscription.nil?
      @plan  = Plan.find(params[:plan_id])
    else
      @plan = current_company.subscription.plan
    end
  end

  def get_plan
    @plan  = Plan.find(params[:plan_id])
    @subscription  = current_company.subscription ||= @plan.subscriptions.build()
  end

  #TODO load_authorize subscription
  def show
    @subscription = current_company.subscription
    @plans = Plan.order(:price)
  end

  def edit
    @prorate = @subscription.get_prorate(@plan.id)
  #TODO get current subscription, option to upgrade, or downgrade (if lowest plan only downgrade)
  end

  def update

    if @subscription.upgrade_to_plan(params[:plan_id])
      redirect_to subscription_path, :notice => "Your subscription has been changed"
    else
      render :edit
    end
  end

 

  def new

    if current_company.subscription
      @update_card = true     

      @subscription = current_company.subscription
      @plan = Plan.find(@subscription.plan_id)


    else
      @update_card = false

      @email = current_company.users.where(:owner => 1).first.email
      #TODO if exists redirect to update, with option to upgrade or downgrade
      @plan = Plan.find(params[:plan_id])
      @subscription = @plan.subscriptions.build()

    end
  end

  def create

    if current_company.subscription
      @update_card = true     
      @subscription = current_company.subscription
                    @plan = Plan.find(@subscription.plan_id)
      
      @subscription.paymill_card_token = params[:subscription][:paymill_card_token]
      if @subscription.save_new_card
        redirect_to subscription_path, :notice => "Your card has been updated"
      else
        render :new
      end
    else
      @update_card = false
      @subscription = Subscription.new(params[:subscription])
      @subscription.company_id = current_company.id

      if @subscription.save_with_payment
        redirect_to subscription_path, :notice => "Thank you for subscribing!"
      else
        render :new
      end
    end

  end

  def destroy

  end

end