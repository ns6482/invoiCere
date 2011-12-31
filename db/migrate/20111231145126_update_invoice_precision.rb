class UpdateInvoicePrecision < ActiveRecord::Migration
  def self.up
        change_column :invoices, :tax_rate, :decimal, { :scale => 2, :precision => 12 }
        change_column :invoices, :delivery_charge, :decimal, { :scale => 2, :precision => 12 }
        change_column :invoices, :late_fee, :decimal, { :scale => 2, :precision => 12 }
        change_column :invoices, :total_cost, :decimal, { :scale => 2, :precision => 12 }
        change_column :invoices, :total_cost_inc_tax, :decimal, { :scale => 2, :precision => 12 }
        change_column :invoices, :total_cost_inc_tax_delivery, :decimal, { :scale => 2, :precision => 12 }
  end

  def self.down
        change_column :invoices, :tax_rate, :decimal
        change_column :invoices, :delivery_charge, :decimal
        change_column :invoices, :late_fee, :decimal
        change_column :invoices, :total_cost, :decimal
        change_column :invoices, :total_cost_inc_tax, :decimal
        change_column :invoices, :total_cost_inc_tax_delivery, :decimal
  end

end
