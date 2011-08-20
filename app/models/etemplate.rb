class Etemplate < ActiveRecord::Base
  belongs_to :company
  attr_protected :company_id
end
