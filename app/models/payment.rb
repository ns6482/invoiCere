class Payment < ActiveRecord::Base
  attr_accessible :invoice_id, :user_id, :amount, :payment_type, :currency, :pay_full_amount
  attr_accessor :pay_full_amount
  belongs_to :invoice
  belongs_to :user

  validates_presence_of :invoice_id,:user_id, :amount
  validates_numericality_of :amount
 
  validate :overpaid?
  validate :invoice_is_open?

  before_validation :set_if_full_amount

  def overpaid? 
    unless amount.nil?
     remaining = self.invoice.remaining_amount
       errors.add :base,  "Amount must be less than or equal to #{remaining}." if self.amount > remaining
     end
  end

  def invoice_is_open?    
     errors.add :base, "Cannot make payment, this invoice is not open" if self.invoice.state == "draft"
  end

  private

  def set_if_full_amount
    if self.pay_full_amount=="1"
      self.amount = self.invoice.remaining_amount
    end
  end
end
