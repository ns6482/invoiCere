
class ActivitiesController < BaseController
  
    #TODO load and authorise
  
    def index
      @activities = current_company.activities.accessible_by(current_ability).order("created_at desc")      
    end
  
end
