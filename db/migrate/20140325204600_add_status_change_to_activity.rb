class AddStatusChangeToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :status_change, :integer
  end
end
