class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable,polymorphic:true
  attr_accessible :action, :trackable
  
  def to_partial_path 
    "activities/#{trackable_type.underscore}/#{trackable_type.underscore}"
  end
  
  #TODO PRESENTER
  def format_action
    action.sub(/e?$/, "ed")
  end
end
