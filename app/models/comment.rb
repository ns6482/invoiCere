class Comment < ActiveRecord::Base
  attr_accessible :title, :message

    belongs_to :invoice
    validates_presence_of :message, :invoice_id
end
