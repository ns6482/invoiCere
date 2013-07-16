require 'prawn'

class ReoccuringInvoice
  @queue = :reoccuring_invoice_queue
  
  
  def self.perform
   
    
    schedules = Invoice.where("type = 'ScheduleInvoice' AND next_send >= ? AND (end_date is null or end_date > ?)", Date.today, Date.today)
    

    schedules.each  do |s|
      s.send_invoice! 
    end
    
  end
  
end