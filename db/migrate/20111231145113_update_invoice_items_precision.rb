class UpdateInvoiceItemsPrecision < ActiveRecord::Migration
  def self.up
        change_column :invoice_items, :qty, :decimal, { :scale => 2, :precision => 12 }
        change_column :invoice_items, :cost, :decimal, { :scale => 2, :precision => 12 }

  end

  def self.down
        change_column :invoice_items, :qty, :decimal
        change_column :invoice_items, :cost, :decimal
  end
end
