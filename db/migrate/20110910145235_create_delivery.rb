class CreateDelivery < ActiveRecord::Migration
  def self.up
    create_table :deliveries, :force => true do |t|
      t.integer  :invoice_id
      t.text     :message
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :client_email
      t.boolean  :schedule
      t.integer  :format
    end
  end

  def self.down
    drop_table :deliveries
  end
end
