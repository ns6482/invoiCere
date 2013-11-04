class Summary < ActiveRecord::Base
  belongs_to :company
  has_many :clients
  
  attr_protected :company_id
  
end
