class Feedback < ActiveRecord::Base
  attr_accessible :message
  belongs_to :invoice
end
