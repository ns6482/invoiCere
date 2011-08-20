class CreateETemplate < ActiveRecord::Migration
  def self.up
      create_table "etemplates", :force => true do |t|
    t.text     "invoice_subject"
    t.text     "invoice_message"
    t.text     "reminder_subject"
    t.text     "reminder_message"
    t.text     "paythank_message"
    t.text     "paythank_subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end
  end

  def self.down
      drop_table "etemplates"
  end
end
