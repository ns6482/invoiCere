require "paymill"

class PaymentStatus
  @queue = :payment_status_queue
  
  
  def self.perform(payment_id)
    
    p = Payment.find(payment_id)
    
    if !p.nil?
      if p.status != "paid"
        transaction =  Paymill::Transaction.find(p.reference)
        if !transaction.nil?
          status = transaction.instance_variable_get('@status')
          p.update_attribute(:status, status == 'closed' ? 'paid' : status) unless p.status == status
        end
      end
     end
        
 end
  
end