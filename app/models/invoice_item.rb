class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice

  validates_presence_of :item_type,:item_description, :qty, :cost
  validates_numericality_of :qty, :cost

  def company_id
    self.invoice.company_id
  end

  def line_cost
    self.cost * self.qty
  end

  def line_cost_inc_tax
   if self.taxable
    val = ((self.cost * self.qty) *  ((self.invoice.tax_rate.to_f + 100)/100))
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
  
end