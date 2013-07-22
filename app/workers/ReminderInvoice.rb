require 'prawn'

class ReminderInvoice
  @queue = :reminder_invoice_queue
  
  
  def self.perform
    

    reminders = Reminder.includes(:invoice).where("reminders.next_send <= ? and invoices.due_amount >0", Date.today)

    reminders.each  do |r|
      
       invoice  = r.invoice
       delivery = invoice.deliveries.build
       delivery.client_email  = true
       delivery.format = r.format
       delivery.message = r.message
       delivery.save
       
       base_link = invoice.base_request
       
       logo_url = invoice.client.company.setting.logo.url
      
  
       #if r.format ==2
         # pdf_file = render_to_string(:action=>'show', :id => invoice_id, :template=>'invoices/show.pdf.prawn')
        #  Notifier.invoice_pdf(delivery, base_link, "#{base_link}/invoices/#{r.invoice.secret_id}", "Payment Reminder").deliver # sends the email
        #elsif r.format ==1            
          Notifier.invoice(delivery, base_link, "#{base_link}/invoices/#{r.invoice.secret_id}", "Payment Reminder").deliver # sends the email
        #end    

    end
    
  end
  
end