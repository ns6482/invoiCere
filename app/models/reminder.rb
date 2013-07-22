class Reminder < ActiveRecord::Base
  attr_accessible :name,  :default_message, :custom_message, :last_send, :next_send, :enabled, :days_before, :last_send_status, :frequency, :format
  belongs_to :invoice
  validates_presence_of :days_before, :frequency
  attr_accessor :message
  
  def remind
      
   n = Time.now
   ns = Time.gm(n.year, n.month, n.day)


    val = case self.frequency
      when "Weekly" then ns + 7.days
      when "Daily" then ns +1.days
      when "Monthly" then ns >> 1
      else ns+1
    end

    
    self.update_attribute("last_send", ns)
    self.update_attribute("next_send", val)
  end

  def message
    val = ''
    if self.enabled ==1
     val= "Reminder set " + self.frequency + ", starting " +  self.invoice.due_date.strftime("%d/%m/%Y")
     val += "A reminder will be sent on " + self.next_send.strftime("%d/%m/%Y") +". "
     val += "The reminder was last sent on "+ self.last_send.strftime("%d/%m/%Y") if self.last_send
    else
     val = "No reminder set"
    end
    
    val
  end
  
end
