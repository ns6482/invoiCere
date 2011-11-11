class AddYearMonthDayToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :yyyy, :integer
    add_column :invoices, :mm, :integer
    add_column :invoices, :dd, :integer
  end

  def self.down
    remove_column :invoices, :dd
    remove_column :invoices, :mm
    remove_column :invoices, :yyyy
  end
end
