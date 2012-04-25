class Preference < ActiveRecord::Base
  
  belongs_to :company
  attr_protected :company_id
  
  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_blank => true, :allow_nil => true  
  validates_numericality_of :shipping
  validates_presence_of :currency_format, :date_format, :time_format
  
  
  def get_format
    format= ""
    if self.date_format = "dt0"
      format = "%Y %B %d" 
    elsif self.date_format = "dt1"
      format = "%d %B %Y"
    elsif self.date_format = "dt2"
      format = "%B %d %Y" 
    elsif self.date_format = "dt3"
      format = "d/%m/%Y" 
    elsif self.date_format = "dt4"
      format = "%Y %m %d" 
    else
      format = "%d %B %Y" 
    end
    

  end
  
  def convert_date(d)
    
    dt = DateTime.new(d.year,d.month, d.day, 00, 00)
    format = get_format
    
    val = dt.strftime(format)
    val

  end
  
    def convert_datetime(d)
    
    dt = DateTime.new(d.year,d.month, d.day, d.hour, d.min)
    format = get_format
    
    if self.time_format = "24"
      format = format + " %H:%M"
    else 
      format= format + " %I:%M"
    end
    
    val = dt.strftime(format)
    val

  end

  
end
