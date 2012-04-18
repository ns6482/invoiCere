class Preference < ActiveRecord::Base
  
  belongs_to :company
  attr_protected :company_id
  
  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_blank => true, :allow_nil => true  
  validates_numericality_of :shipping
  validates_presence_of :currency_format, :date_format, :time_format

  def convert_date(d)
    
    dt = DateTime.new(d.year,d.month, d.day, 00, 00)
    
    if self.date_format = "dt0"
      val = dt.strftime("%Y %B %d") 
    elsif self.date_format = "dt1"
      val = dt.strftime("%d %B %Y") 
    elsif self.date_format = "dt2"
      val = dt.strftime("%B %d %Y") 
    elsif self.date_format = "dt3"
      val = dt.strftime("d/%m/%Y") 
    elsif self.date_format = "dt4"
      val = dt.strftime("%Y %m %d") 
    else
      val = dt.strftime("%d %B %Y") 
    end
    val
  end
  
end
