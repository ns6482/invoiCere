class AddBaseRequestToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :base_request, :string 
  end
end
