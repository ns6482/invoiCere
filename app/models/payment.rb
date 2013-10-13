class Payment < ActiveRecord::Base
  attr_accessible :invoice_id, :user_id, :amount, :payment_type, :currency, :pay_full_amount,:paymill_card_token, :amount_cents
  attr_accessor :pay_full_amount
  belongs_to :invoice
  belongs_to :user

  validates_presence_of :invoice_id,:user_id , :amount
  validates_numericality_of :amount
 
  validate :overpaid?
  validate :invoice_is_open?

  before_validation :set_if_full_amount
  
  
  before_save :set_if_full_amount
  after_save :check_if_paid
  after_destroy :update_invoice_when_deleted
  after_update  :update_invoice_when_status
  
  attr_accessor :paymill_card_token
  
  #after_destroy :reopen

  monetize :amount, :as => "amount_cents"
  
  
  def overpaid? 
    unless amount.nil?
     remaining = self.invoice.remaining_amount
       errors.add :base,  "Amount must be less than or equal to #{remaining}." if self.amount > remaining
     end
  end

  def invoice_is_open?    
     errors.add :base, "Cannot make payment, this invoice is not open" if self.invoice.state == "draft"
  end

  def save_paymill
     # logger.debug "token:"
     # logger.debug self.paymill_card_token
    if valid?        
              
      payment = Paymill::Transaction.create token: self.paymill_card_token, amount: self.amount, currency: self.currency, description: self.id
      self.reference = payment.id
      if save! #TODO paymill webhook to alter status
        Resque.enqueue(PaymentStatus, self.id)
      end
            
    end
  rescue Paymill::PaymillError => e
    logger.error "Payment Error: #{e.message}"
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
  end

  private

  def set_if_full_amount
    if self.pay_full_amount=="1"
      self.amount = self.invoice.remaining_amount
    end
  end
  
  def check_if_paid
    if self.invoice.remaining_amount ==0 and self.invoice.state == "open" 
      self.invoice.pay!
    else
      Invoice.update_all("due_amount = #{self.invoice.remaining_amount}","id=#{self.invoice.id}")
    end
  end
  

  def update_invoice_when_deleted
      if self.invoice.state == "paid"
        self.invoice.open_again!
      end
  end
  
  def update_invoice_when_status
    
     if self.status == "cancelled" and self.invoice.state == "paid"
        self.invoice.open_again!
      end

  end
  
  
  
  

  #TODO - on delete need to reset to open invoice
  
end
