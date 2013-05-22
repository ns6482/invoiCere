
class Schedule < ActiveRecord::Base
  
  DUE_DAYS_LIST = {
    0 => "On Receipt",
    15 => "After 15 Days",
    30 => "After 30 Days",
    45 => "After 45 Days",
    60 => "After 60 Days" 
   } 

  attr_accessible :client_id, :name, :format, :frequency, :frequency_type, :last_sent, :next_send, :send_client, :due_on, :enabled, :end_date, :contact_ids, :send_to_client,:default_message, :custom_message, :title, :business_id, :purchase_order_id, :tax_rate, :delivery_charge, :late_fee, :discount, :schedule_items_attributes, :notes, :draft_only, :currency, :payables

  belongs_to :client

  has_many :schedule_sends
  has_many :contacts, :through => :schedule_sends
  has_many :schedule_items, :dependent => :destroy


  accepts_nested_attributes_for :contacts
  accepts_nested_attributes_for :schedule_items, :reject_if => :all_blank, :allow_destroy => true


  validates_presence_of :name, :next_send, :frequency, :frequency_type, :title, :client_id, :due_on
  validates_numericality_of :due_on, :frequency
  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_nil => true  


  monetize :delivery_charge, :as => "delivery_charge_cents"

  PAYABLES = %w[Paypal GoCardless Paymill]
  
  def payables=(payables)
    self.payables_mask = (payables & PAYABLES).map { |r| 2**PAYABLES.index(r) }.inject(0, :+)
  end

  def payables
    PAYABLES.reject do |r|
      ((payables_mask || 0) & 2**PAYABLES.index(r)).zero?
    end
  end
  
  def can_pay_through?(payable)
    payables.include?(payable.to_s) or payable == "Manual"
  end


  def send_invoice!

    #master_invoice = self.invoice        
    #invoice  = master_invoice.clone :include => :invoice_items
        
    invoice = Invoice.new
    invoice.client_id = self.client_id     
       
    
    if self.draft_only 
     invoice.state = "draft"
    else
     invoice.state = "open"
    end
    
    invoice.invoice_date=Date.today  
    invoice.title = self.title
    invoice.notes = self.notes
    invoice.tax_rate = self.tax_rate
    invoice.delivery_charge = self.delivery_charge
    invoice.business_id = self.business_id
    invoice.purchase_order_id = self.purchase_order_id
    invoice.late_fee = self.late_fee
    invoice.discount = self.discount 
    invoice.due_date = Date.today + (self.due_on ||= 0)
    invoice.due_days = self.due_on ||= 0
    invoice.currency = self.currency
    invoice.payables = self.payables
    
    invoice.save!
    
   self.schedule_items.each do |s|
      i = InvoiceItem.new
      i.invoice_id = invoice.id 
      i.item_description = s.item_description
      i.qty =  s.qty
      i.cost= s.cost
      i.item_type =  s.item_type
      i.taxable = s.taxable
      i.save!
    end
    
    
    self.last_sent = Date.today
    self.next_send = get_next_send
    
    self.save!
    
      
    delivery = Delivery.new(:invoice_id => invoice.id, :message => self.message, :client_email => send_to_client, :format => self.format)
    delivery.schedule = 1
    
    self.schedule_sends.each do |send|
      delivery.contacts << send.contact
    end
    
    if delivery.format ==2
     # pdf_file = render_to_string(:action=>'show', :id => invoice_id, :template=>'invoices/show.pdf.prawn')
      Notifier.invoice_pdf(delivery, self.base_link, "#{self.base_link}/invoices/#{delivery.invoice.secret_id}").deliver # sends the email
    elsif delivery.format ==1            
      Notifier.invoice(delivery, self.base_link, "#{self.base_link}/invoices/#{delivery.invoice.secret_id}").deliver # sends the email
    end    

    
    #Notifier.invoice(delivery) # sends the email
    
    #Notifier.deliver_schedule(invoice, self)

    return invoice    
  end

  def get_next_send

    case self.frequency_type
    when "Daily"
      val = Date.today + self.frequency
    when "Weekly"
      val = Date.today + (self.frequency * 7)
    when "Monthly"
      val = Date.today >> self.frequency
    when "Yearly"
      val = Date.today >> (12 * self.frequency)
    else
      val =  Date.today + self.frequency
    end

    return val
  end

  def recipients

    recipients = Array.new

    if self.send_to_client
      recipients << "\"#{self.invoice.client.company_name}\" <#{self.invoice.client.email}>"
    end

    for contact in self.contacts
      recipients << "\"#{contact.fullname.to_s}\" <#{contact.email.to_s}>"
    end

    recipients
    #    self.contacts.inject("") { |acc, contact| acc <<  "\"#{contact.fullname}\" <#{contact.email}>"}
  end
end
