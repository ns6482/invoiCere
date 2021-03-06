# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20140327135143) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "status_change"
    t.integer  "company_id"
  end

  add_index "activities", ["trackable_id"], :name => "index_activities_on_trackable_id"
  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

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
    t.string   "slug"
    t.string   "business_id"
  end

  add_index "clients", ["slug"], :name => "index_clients_on_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "invoice_id"
    t.string   "title"
    t.text     "message"
    t.string   "user_id"
    t.string   "user_name"
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

  create_table "deliveries", :force => true do |t|
    t.integer  "invoice_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "client_email"
    t.boolean  "schedule"
    t.integer  "format"
    t.string   "emails"
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

  create_table "feedbacks", :force => true do |t|
    t.integer  "invoice_id"
    t.string   "user_name"
    t.string   "user_email"
    t.integer  "rating"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.string   "item_type",        :limit => 20,                                 :null => false
    t.string   "item_description", :limit => 100,                                :null => false
    t.decimal  "qty",                             :precision => 12, :scale => 2, :null => false
    t.integer  "cost",                                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "taxable"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "client_id"
    t.date     "invoice_date"
    t.string   "title"
    t.text     "notes"
    t.decimal  "tax_rate",                    :precision => 12, :scale => 2
    t.integer  "delivery_charge"
    t.string   "business_id"
    t.string   "purchase_order_id"
    t.string   "status"
    t.decimal  "late_fee",                    :precision => 12, :scale => 2
    t.integer  "due_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "total_cost"
    t.integer  "total_cost_inc_tax"
    t.integer  "total_cost_inc_tax_delivery"
    t.date     "due_date"
    t.date     "opened_date"
    t.string   "opened_by"
    t.date     "paid_date"
    t.string   "paid_by"
    t.boolean  "cancelled"
    t.date     "cancelled_date"
    t.string   "cancelled_by"
    t.integer  "seed_schedule_id"
    t.boolean  "latest"
    t.integer  "yyyy"
    t.integer  "mm"
    t.integer  "dd"
    t.string   "discount"
    t.string   "currency"
    t.integer  "due_amount"
    t.string   "secret_id"
    t.integer  "payables_mask"
    t.string   "name"
    t.integer  "frequency"
    t.string   "frequency_type"
    t.date     "last_sent"
    t.date     "next_send"
    t.integer  "due_on"
    t.date     "end_date"
    t.integer  "enabled"
    t.integer  "send_to_client"
    t.text     "message"
    t.integer  "default_message"
    t.text     "custom_message"
    t.integer  "format"
    t.boolean  "draft_only"
    t.string   "base_request"
    t.string   "type"
    t.boolean  "payment_reminder"
    t.boolean  "send_email"
    t.integer  "repeats_left"
    t.string   "emails"
    t.boolean  "client_email"
    t.string   "slug"
    t.integer  "user_id"
  end

  add_index "invoices", ["slug"], :name => "index_invoices_on_slug", :unique => true

  create_table "items", :force => true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "description"
    t.string   "unit"
    t.decimal  "price",       :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "payment_type"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference"
    t.string   "status"
  end

  create_table "plans", :force => true do |t|
    t.string   "paymill_id"
    t.string   "name"
    t.float    "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "preferences", :force => true do |t|
    t.string   "currency_format"
    t.string   "date_format"
    t.string   "time_format"
    t.string   "number_format"
    t.string   "fiscal"
    t.decimal  "tax",                   :precision => 10, :scale => 0
    t.decimal  "discount",              :precision => 10, :scale => 0
    t.decimal  "shipping",              :precision => 10, :scale => 0
    t.boolean  "purchase_order_number"
    t.boolean  "email_alerts"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.text     "payment_instruction"
    t.text     "footer"
    t.string   "fiscal_start"
    t.string   "fiscal_end"
  end

  create_table "reminders", :force => true do |t|
    t.integer  "default_message",  :default => 0
    t.text     "custom_message"
    t.datetime "last_send"
    t.datetime "next_send"
    t.integer  "enabled",          :default => 0
    t.integer  "days_before"
    t.string   "last_send_status"
    t.string   "frequency"
    t.string   "name"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "format"
    t.string   "emails"
    t.boolean  "client_email"
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

  create_table "schedule_items", :force => true do |t|
    t.integer  "schedule_id",                                                    :null => false
    t.string   "item_type",        :limit => 20,                                 :null => false
    t.string   "item_description", :limit => 100,                                :null => false
    t.decimal  "qty",                             :precision => 10, :scale => 0, :null => false
    t.integer  "cost",                                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "taxable"
  end

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.integer  "frequency"
    t.string   "frequency_type"
    t.date     "last_sent"
    t.date     "next_send"
    t.integer  "due_on"
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
    t.decimal  "tax_rate",          :precision => 10, :scale => 0
    t.integer  "delivery_charge"
    t.string   "purchase_order_id"
    t.string   "business_id"
    t.integer  "late_fee"
    t.decimal  "discount",          :precision => 10, :scale => 0
    t.integer  "format"
    t.boolean  "draft_only"
    t.integer  "payables_mask"
    t.string   "currency"
    t.string   "base_request"
  end

  create_table "sends", :force => true do |t|
    t.integer  "contact_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sendable_type"
    t.integer  "sendable_id"
  end

  create_table "settings", :force => true do |t|
    t.decimal  "vat",                  :precision => 10, :scale => 0
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
    t.string   "pay_gc_token"
    t.integer  "pay_gc_enabled"
    t.string   "paypal_login"
    t.string   "paypal_sig"
    t.string   "paypal_pwd"
    t.string   "paypal_enabled"
    t.string   "paymill_public_key"
    t.string   "paymill_enabled"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "company_id"
    t.string   "paymill_id"
    t.integer  "plan_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "summaries", :force => true do |t|
    t.integer  "company_id"
    t.integer  "client_id"
    t.string   "currency"
    t.integer  "total_due"
    t.integer  "total_amount_open"
    t.integer  "total_amount_closed"
    t.integer  "count_invoices_open"
    t.integer  "count_due"
    t.integer  "count_invoices_due"
    t.integer  "count_invoices_closed"
    t.integer  "count_invoices_draft"
    t.datetime "min_due_date"
    t.integer  "yr"
    t.integer  "mo"
    t.integer  "tax_year"
    t.integer  "total_payments"
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
    t.datetime "invitation_accepted_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email", "company_id"], :name => "index_users_on_email_and_company_id", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
