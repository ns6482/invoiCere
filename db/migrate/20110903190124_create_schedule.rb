class CreateSchedule < ActiveRecord::Migration
  def self.up
      create_table "schedules", :force => true do |t|
        t.string   "name"
        t.integer  "invoice_id"
        t.integer  "frequency"
        t.string   "frequency_type"
        t.date     "last_sent"
        t.date     "next_send"
        t.string   "due_on"
        t.date     "end_date"
        t.integer  "enabled"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "send_to_client"
        t.text     "message"
        t.integer  "default_message"
        t.text     "custom_message"
      end
  end

  def self.down
    drop_table "schedules"
  end
end
