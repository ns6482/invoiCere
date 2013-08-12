require 'mail'
require 'money'

class Delivery < ActiveRecord::Base
  attr_accessible :invoice_id, :message, :contact_ids, :recipients, :client_email, :format, :emails
  attr_accessor :company_id
  
  liquid_methods :invoice_title, :company_name, :company_email, :company_fax, :company_phone, :company_website, :client_name, :invoice_id, :direct_link, :invoice_date, :invoice_title, :invoice_due_date, :invoice_total_due, :payment_instruction

  belongs_to :invoice
  
  has_many :sends, :as => :sendable
  has_many :contacts, :through => :sends
  
  accepts_nested_attributes_for :contacts

  validates_presence_of :message

  #validate :has_contacts?
  validate :check_email?
  
  validates_format_of :emails, :with => /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/,  :unless => Proc.new {|i| i.emails.blank?}

  def check_email?
    if self.emails.blank? and self.client_email==0 and self.invoice.client.email.length > 0  and self.contacts.blank?
      errors.add :base, "Please choose at least one email address"
    end 
  end


  def recipients

    recipients = Array.new

    if self.client_email and self.invoice.client.email.length >0
      recipients << "\"#{self.invoice.client.company_name}\" <#{self.invoice.client.email}>"
    end

    for contact in self.contacts
      recipients << "\"#{contact.fullname.to_s}\" <#{contact.email.to_s}>"
    end
    
    recipients << self.emails
    
    recipients
    #    self.contacts.inject("") { |acc, contact| acc <<  "\"#{contact.fullname}\" <#{contact.email}>"}
  end

  def recipient_names
    contacts.collect{|c | c.fullname}.join(", ")        
  end

  def message_short 
    self.message.first(47) << "..."
  end

  def company_id
    self.invoice.company_id
  end

  def invoice_title
    self.invoice.title
  end
  
  def company_name
    Company.find(self.invoice.client.company_id).name  
  end
  
  def company_email
    Company.find(self.invoice.client.company_id).setting.email
  end
  
  def company_fax
    Company.find(self.invoice.client.company_id).setting.fax
  end
  
  def company_phone
    Company.find(self.invoice.client.company_id).setting.telephone
  end
  
  def company_contact
    Company.find(self.invoice.client.company_id).setting.contact
  end
  
  def company_website
    #TODO company_website placeholder
  end
    
  def client_name
    self.invoice.client.name
  end
  
  def invoice_id
    self.invoice.id
  end
    
  def invoice_date
    self.invoice.invoice_date
  end
  
  def invoice_due_date
    self.invoice.due_date
  end
  
  def invoice_total_due
    Money.new(self.invoice.remaining_amount, self.invoice.currency).format(:symbol => true)
  end
  
  def invoice_paid_total 
    self.invoice.total_cost_inc_tax_delivery - self.invoice.remaining_amount 
  end
  
  def payment_instruction
    Company.find(self.invoice.client.company_id).preference.payment_instruction
  end
  
  
  
 
       
end
