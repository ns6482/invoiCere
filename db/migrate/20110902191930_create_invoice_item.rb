class CreateInvoiceItem < ActiveRecord::Migration
  def self.up
    create_table :invoice_items, :force => true do |t|
      t.integer  :invoice_id
      t.string   :item_type,        :limit => 20,  :null => false
      t.string   :item_description, :limit => 100, :null => false
      t.decimal  :qty,                             :null => false
      t.decimal  :cost,                            :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :taxable
    end

  end

  def self.down
    drop_table :invoice_items  
  end
end
