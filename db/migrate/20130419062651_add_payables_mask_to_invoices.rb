class AddPayablesMaskToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :payables_mask, :integer
  end
end
