class AddEmailsToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :emails, :string
  end
end
