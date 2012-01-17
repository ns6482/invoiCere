class CreateInvoice < ActiveRecord::Migration
  def self.up
    create_table :invoices, :force => true do |t|
      t.integer  :client_id
      t.date     :invoice_date
      t.string   :title
      t.text     :notes
      t.decimal  :tax_rate
      t.decimal  :delivery_charge
      t.string   :business_id
      t.string   :purchase_order_id
      t.string   :status
      t.decimal  :late_fee
      t.integer  :due_days
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :state
      t.decimal  :total_cost
      t.decimal  :total_cost_inc_tax
      t.decimal  :total_cost_inc_tax_delivery
      t.date     :due_date
      t.date     :opened_date
      t.string   :opened_by
      t.date     :paid_date
      t.string   :paid_by
      t.boolean  :cancelled
      t.date     :cancelled_date
      t.string   :cancelled_by
      t.integer  :seed_schedule_id
      t.boolean  :latest
      t.string,  :discount

    end
  end

  def self.down
    drop_table :clients  
  end
end
