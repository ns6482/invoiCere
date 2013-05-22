class AddPayablesMaskToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :payables_mask, :integer
    add_column :schedules, :currency, :string
 
  end
end
