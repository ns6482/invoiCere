class Item < ActiveRecord::Base
  attr_protected :company_id 
  
  attr_accessible :name, :description, :unit, :price


  belongs_to :company

  validates_presence_of :name,:description, :unit, :price, :company_id
  validates_numericality_of  :price


end
