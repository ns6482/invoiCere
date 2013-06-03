class ScheduleSend < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :contact
  
  attr_accessor :company_id

   def company_id
    self.client.company_id
  end

end
