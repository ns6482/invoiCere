class CreatePayment < ActiveRecord::Migration
  def self.up
    create_table :payments, :force => true do |t|
      t.integer  :invoice_id
      t.integer  :user_id
      t.decimal  :amount
      t.string   :payment_type
      t.string   :currency
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :payments
  end
end
