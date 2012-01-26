class Schedule < ActiveRecord::Base
  
  DUE_DAYS_LIST = {
    0 => "On Receipt",
    15 => "After 15 Days",
    30 => "After 30 Days",
    45 => "After 45 Days",
    60 => "After 60 Days" 
   } 

  attr_accessible :name,  :frequency, :frequency_type, :last_sent, :next_send, :send_client, :due_on, :enabled, :end_date, :contact_ids, :send_to_client,:default_message, :custom_message, :title, :business_id, :purchase_order_id, :tax_rate, :delivery_charge, :late_fee, :discount, :schedule_items_attributes, :notes

  belongs_to :client

  has_many :schedule_sends
  has_many :contacts, :through => :schedule_sends
  has_many :schedule_items, :dependent => :destroy


  accepts_nested_attributes_for :contacts
  accepts_nested_attributes_for :schedule_items, :reject_if => :all_blank, :allow_destroy => true


  validates_presence_of :name, :next_send, :frequency, :frequency_type, :title, :client_id, :due_on
  validates_numericality_of :due_on, :frequency
  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_nil => true  


  def send_invoice!

    #master_invoice = self.invoice        
    #invoice  = master_invoice.clone :include => :invoice_items
        
    invoice = Invoice.new
    invoice.client_id = self.client_id 
    invoice.state = "open"
    
    
    #TODO add schedule draft only option
    #if self.draft_only 
     #invoice.state = "draft"
    #else
     #invoice.state = "open"
    #end
    
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
    
    invoice.save!
    
   self.schedule_items.each do |s|
      i = InvoiceItem.new(:invoice_id => invoice.id, :item_description => s.item_description,  :qty => s.qty, :cost => s.cost, :item_type => s.item_type)
      i.save!
    end
    
    
    self.last_sent = Date.today
    self.next_send = get_next_send
    
    self.save!
    
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
