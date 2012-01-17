class CreateSchedule < ActiveRecord::Migration
  def self.up
     create_table "schedules", :force => true do |t|
        t.string   "name"
        t.integer  "client_id"
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
        t.string   "title"
        t.text     "notes"
        t.decimal  "tax_rate"
        t.decimal  "delivery_charge"
        t.string   "purchase_order_id"
        t.string   "business_id"
        t.decimal  "late_fee"
        t.decimal  "discount"
      end
  end

  def self.down
        drop_table "schedules"
  end
end
