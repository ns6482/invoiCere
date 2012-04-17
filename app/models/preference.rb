class Preference < ActiveRecord::Base
  
  belongs_to :company
  attr_protected :company_id
  
  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_blank => true, :allow_nil => true  
  validates_numericality_of :shipping
  validates_presence_of :currency_format, :date_format, :time_format

end
