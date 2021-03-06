class Subscription < ActiveRecord::Base
  attr_accessible :paymill_id, :plan_id, :paymill_card_token
  belongs_to :plan
  belongs_to :company
  
  validates_presence_of :plan_id
  validates_presence_of :company_id
  
  attr_accessor :paymill_card_token
  
  
  def next_capture_at
    
    s = Paymill::Subscription.find(self.paymill_id)
    d = s.instance_variable_get('@next_capture_at')
    
      rescue Paymill::PaymillError => e
      logger.error "Paymill error while getting next capture #{e.message}"
      false
    
  end
  
  
  def get_prorate(new_plan_id)
    
    #get new plan details
    new_plan = Plan.find(new_plan_id)   
         
    #find out when the next billing date is      
    next_bill = Time.at(Paymill::Subscription.find(self.paymill_id).instance_variable_get('@next_capture_at')).to_datetime
    
   
    #get the number of days used since last payment    
    used_days = (DateTime.now - (next_bill << 1)).to_i
    
    if used_days.abs == 0 
      self.plan.price * -1
    else
      #total days in month for previous month
      number_of_days_previous_month = ((DateTime.new next_bill.year, next_bill.month, 1)-1).day
     
      #used days / days in month * price diff will give us the pro-rated value 
      price_diff = (new_plan.price - self.plan.price)
    
      (used_days.to_d / number_of_days_previous_month.to_d) * price_diff 
 
    end
        
    
    rescue Paymill::PaymillError => e
      logger.error "Paymill error while updating prorate #{e.message}"
      false
    end
  

  
  
  def upgrade_to_plan(plan_id)
    
    #TODO add more offers that have no trial period, if upgrading or downgrading cannot have offer. Should be one off.
    #TODO check currency and plan are amount have not been altered
      plan = Plan.find(plan_id)  
    
      subscription = Paymill::Subscription.find(self.paymill_id)
      client =  subscription.client        
      #delete existing subscription
      
      payment = subscription.instance_variable_get('@payment')['id']

      #if upgrading need to make pro-rated payment
      
      prorate = (get_prorate(plan.id).round(2) * 100).to_i

      if prorate > 0           
        Paymill::Transaction.create(amount: prorate, currency: 'gbp', payment: payment['id'], description: 'prorate ' +  self.paymill_id)
      elsif prorate < 0
        trans = "Subscription#" + subscription.instance_variable_get("@id") + " "  + subscription.instance_variable_get('@offer')['name']
        transaction_id = Paymill::Transaction.all(:description => trans, :order => 'created_at desc', status: 'closed').first.id          
        Paymill::Refund.create(id: transaction_id, amount: prorate.abs)
      end          
      #else if downgrading need to make pro-rated  partial refund, from the last subscription transaction
       
      
      #subscription.update_attributes :offer => plan.paymill_id
      if Paymill::Subscription.delete(self.paymill_id)      
        if plan.price > 0 
          #create new subscription
        
          subscription = Paymill::Subscription.create offer: plan.paymill_id, client: client['id'], payment: payment
          self.update_attributes(:plan_id => plan_id, :paymill_id => subscription.id)
        else
          self.delete
        end
      end
    
  
       
    rescue Paymill::PaymillError => e
      logger.error "Paymill error while upgrading plan: #{e.message}"
      errors.add :base, "There was a problem with your upgrade, please contact customer services."
      false
 
  end
  
   def save_new_card
     # logger.debug "token:"
     # logger.debug self.paymill_card_token
    if valid?
      
      subscription = Paymill::Subscription.find(self.paymill_id)
      client =  subscription.client      
          
      payment = Paymill::Payment.create token: self.paymill_card_token, client: client['id']
      subscription.update_attributes  payment: payment.id
 
      self.update_attribute(:paymill_id, subscription.id)
     
    end
  rescue Paymill::PaymillError => e
    logger.error "Paymill error while creating customer: #{e.message}"
    
    
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
  end

  
  
    def save_with_payment
    if valid?
      
      email = self.company.users.where(:owner => 1).first.email
      client = Paymill::Client.create email: email, description: self.company.name
     
      payment = Paymill::Payment.create token: self.paymill_card_token, client: client.id
      subscription = Paymill::Subscription.create offer: plan.paymill_id, client: client.id, payment: payment.id
 
      self.paymill_id = subscription.id
      save!
    end
  rescue Paymill::PaymillError => e
    logger.error "Paymill error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
  end
  

  
end