class Item < ActiveRecord::Base
  attr_protected :company_id 
  
  attr_accessible :name, :description, :unit, :price


  belongs_to :company

  validates_presence_of :name,:description, :unit, :price, :company_id
  validates_numericality_of  :price


def self.to_csv(all_items) 
        CSV.generate do |csv|
            csv << ["Name", "Description", "Unit", "Price", "Created"]           
            all_items.each do |item|
              csv << [item.name, item.description, item.unit, item.price, item.created_at]
            end
        end
end


end
