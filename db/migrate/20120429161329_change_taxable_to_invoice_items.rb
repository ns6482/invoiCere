class ChangeTaxableToInvoiceItems < ActiveRecord::Migration
  def self.up
    change_column :invoice_items, :taxable, :integer
  end

  def self.down
    change_column :invoice_items, :taxable, :tiny_int
  end
end
