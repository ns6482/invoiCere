require 'prawn'

class DeliveryMailer
  @queue = :delivery_queue
  
  
  def self.perform(delivery_id, base_link)
    delivery = Delivery.find(delivery_id)
    invoice_id  = delivery.invoice_id
    logo_url = delivery.invoice.client.company.setting.logo.url

    if delivery.format ==2
     # pdf_file = render_to_string(:action=>'show', :id => invoice_id, :template=>'invoices/show.pdf.prawn')
      Notifier.invoice_pdf(delivery, base_link, "#{base_link}/invoices/#{delivery.invoice.secret_id}").deliver # sends the email
    elsif delivery.format ==1            
      Notifier.invoice(delivery, base_link, "#{base_link}/invoices/#{delivery.invoice.secret_id}").deliver # sends the email
    end    
  end
  
end

