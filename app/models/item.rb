class Item < ActiveRecord::Base
  attr_protected :company_id 
  
  attr_accessible :name, :description, :unit, :price


  belongs_to :company

  validates_presence_of :name,:description, :unit, :price, :company_id
  validates_numericality_of  :price

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end
 
end
