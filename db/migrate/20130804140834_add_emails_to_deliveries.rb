class AddEmailsToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :emails, :string
  end
end
