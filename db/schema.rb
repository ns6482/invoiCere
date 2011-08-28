# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110828161024) do

  create_table "clients", :force => true do |t|
    t.string   "company_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "contact_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.string   "fax"
    t.string   "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "settings", :force => true do |t|
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

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "owner",                                 :default => false
    t.string   "name"
    t.integer  "client_id"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email", "company_id"], :name => "index_users_on_email_and_company_id", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
