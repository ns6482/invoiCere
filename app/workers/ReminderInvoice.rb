require 'prawn'

class ReminderInvoice
  @queue = :reminder_invoice_queue
  
  
  def self.perform
    

    reminders = Reminder.includes(:invoice).where("reminders.next_send <= ? and invoices.due_amount >0 and reminders.enabled=1", Date.today)

    reminders.each  do |r|
      
       invoice  = r.invoice
       delivery = invoice.deliveries.build
       delivery.client_email  = true
       delivery.format = r.format
       delivery.message = r.custom_message
       delivery.save
       
       base_link = invoice.base_request
       
       logo_url = invoice.client.company.setting.logo.url
      
  
       
        if r.format =="1"            
          Notifier.invoice(delivery, base_link, "#{base_link}/invoices/#{r.invoice.secret_id}", "Payment Reminder").deliver # sends the email
        else        
          Notifier.invoice_pdf(delivery, base_link, "#{base_link}/invoices/#{r.invoice.secret_id}", "Payment Reminder").deliver # sends the email
        end
        
        r.remind    

    end
    
  end
  
end