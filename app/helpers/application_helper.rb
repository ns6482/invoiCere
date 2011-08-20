module ApplicationHelper
  def setup_user(user)           
    user.build_company
    user
  end
end
