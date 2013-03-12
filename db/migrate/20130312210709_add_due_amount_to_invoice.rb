class AddDueAmountToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :due_amount, :decimal
  end
end
