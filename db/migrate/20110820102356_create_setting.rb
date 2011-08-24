class CreateSetting < ActiveRecord::Migration
  def self.up
      create_table "settings", :id => false, :force => true do |t|
        #t.integer  "id",                     :null => false
        t.decimal  "vat"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "company_id"
        t.string   "logo_file_name"
        t.string   "logo_content_type"
        t.integer  "logo_file_size"
        t.datetime "logo_updated_at"
        t.string   "company_name"
        t.string   "company_registration"
        t.text     "address"
        t.string   "telephone"
        t.string   "fax"
        t.string   "email"
        t.string   "vat_registration"
        t.text     "payment_instructions_1"
      end
  end
  
  def self.down
        drop_table "settings"
  end
end


