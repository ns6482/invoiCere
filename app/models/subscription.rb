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
  end
  
  
  def upgrade_to_plan(plan_id)
    
    
    #TODO add more offers that have no trial period, if upgrading or downgrading cannot have offer. Should be one off.
    
    if self.paymill_id 
        
      plan = Plan.find(plan_id)  
    
      if plan.paymill_id
        
        if plan.price > 0  then
        
          subscription = Paymill::Subscription.find(self.paymill_id)
          offer = Paymill::Offer.find(plan.paymill_id)
          subscription.update_attributes :offer => plan.paymill_id
          self.update_attribute(:plan_id, plan_id)

        else
          Paymill::Subscription.delete(self.paymill_id)
          self.delete
        end        
      end
   
    end  
       
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