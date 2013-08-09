class ReminderSend < ActiveRecord::Base
  belongs_to :reminder_invoice
  belongs_to :contact
  
  attr_accessor :company_id

   def company_id
    self.invoice.client.company_id
  end

end
