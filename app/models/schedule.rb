class Schedule < ActiveRecord::Base
  attr_accessible :name,  :frequency, :frequency_type, :last_sent, :next_send, :send_client, :due_on, :enabled, :end_date, :contact_ids, :send_to_client,:default_message, :custom_message

  belongs_to :invoice

  #has_many :schedule_sends
  has_many :contacts, :through => :schedule_sends

  accepts_nested_attributes_for :contacts

  def send_invoice!
    invoice = self.invoice.clone_with_associations
    invoice.seed_schedule_id = self.id
    self.last_sent = Date.today
    #Notifier.deliver_schedule(invoice, self)
    self.next_send = get_next_send
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
