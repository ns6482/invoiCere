require 'mail'

class Delivery < ActiveRecord::Base
  attr_accessible :invoice_id, :message, :contact_ids, :recipients, :client_email, :format
  attr_accessor :company_id
  

  belongs_to :invoice
  
  has_many :sends
  has_many :contacts, :through => :sends
  
  accepts_nested_attributes_for :contacts

  validates_presence_of :message

  validate :has_contacts?

  def has_contacts?
    if self.contacts.blank? and !self.client_email
      errors.add_to_base "Please select at least one email address"
    end
  end

  def recipients

    recipients = Array.new

    if self.client_email
      recipients << "\"#{self.invoice.client.company_name}\" <#{self.invoice.client.email}>"
    end

    for contact in self.contacts
      recipients << "\"#{contact.fullname.to_s}\" <#{contact.email.to_s}>"
    end
    
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


end
