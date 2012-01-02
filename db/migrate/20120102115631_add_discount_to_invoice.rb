class AddDiscountToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :discount, :string
  end

  def self.down
    remove_column :invoices, :discount
  end
end
