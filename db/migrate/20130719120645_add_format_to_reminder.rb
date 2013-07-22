class AddFormatToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :format, :string
  end
end
