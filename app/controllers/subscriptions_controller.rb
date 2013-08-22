class SubscriptionsController < BaseController

  before_filter  :get_plan, :only => [:edit, :update]
  before_filter  :get_plan_new, :only => [:new ]

def get_plan_new
    @plan  = Plan.find(params[:plan_id])
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
    #TODO get current subscription, option to upgrade, or downgrade (if lowest plan only downgrade)
  end

  def update

    if @subscription.upgrade_to_plan(params[:plan_id])
      redirect_to @subscription, :notice => "Thank you for subscribing to the #{@subscription.plan.name} plan"
    else
      render :edit
    end
  end



  def new
    if !@subscription.nil?
          redirect_to edit_subscription_url(:plan_id => @plan.id)
    else
       @email = current_company.users.where(:owner => 1).first.email
             #TODO if exists redirect to update, with option to upgrade or downgrade
      plan = Plan.find(params[:plan_id])
      @subscription = plan.subscriptions.build()

    end
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @subscription.company_id = current_company.id

    if @subscription.save_with_payment
      redirect_to @subscription, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end

  def destroy

  end



end