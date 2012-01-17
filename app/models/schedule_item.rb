class ScheduleItem < ActiveRecord::Base
  belongs_to :schedule

  validates_presence_of :item_type,:item_description, :qty, :cost
  validates_numericality_of :qty, :cost

end
