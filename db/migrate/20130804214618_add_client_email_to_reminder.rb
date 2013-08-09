class AddClientEmailToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :client_email, :boolean
  end
end
