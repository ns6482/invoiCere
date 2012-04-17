class AddCurrencyDateDisplayToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :currency, :string
    add_column :invoices, :date_display, :string
  end

  def self.down
    remove_column :invoices, :date_display
    remove_column :invoices, :currency
  end
end
