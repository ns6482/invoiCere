class CreateReminder < ActiveRecord::Migration
  def self.up
    create_table :reminders, :force => true do |t|
      t.integer  :default_message,  :default => 0
      t.text     :custom_message
      t.datetime :last_send
      t.datetime :next_send
      t.integer  :enabled,          :default => 0
      t.integer  :days_before
      t.string   :last_send_status
      t.string   :frequency
      t.string   :name
      t.integer  :invoice_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :reminders
  end
end
