class AddRepeatsLeftToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :repeats_left, :integer
  end
end
