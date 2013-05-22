class ScheduleItem < ActiveRecord::Base
  belongs_to :schedule

  validates_presence_of :item_type,:item_description, :qty, :cost
  validates_numericality_of :qty, :cost

  attr_protected :id

  monetize :cost, :as => "cost_cents"
  monetize :line_cost_inc_tax, :as => "line_cost_inc_tax_cents"


 def line_cost
    self.cost * self.qty
  end

  def line_cost_inc_tax
   if self.taxable==1
    val = ((self.cost * self.qty) *  (((self.schedule.tax_rate ||=1) + 100)/100))
   else
     val = self.cost * self.qty
   end

    val

   # if self.taxable
   #   self.qty * self.cost * self.invoice.tax_rate
  #  else
   #   self.total_cost
  #  end
   
  end
  
   def show_tax
    if self.taxable == 1
      val = self.schedule.tax_rate.to_s + "%" 
    else
      val = ""
    end
    
    val
  end
  

end
