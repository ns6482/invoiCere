class AddEmailsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :emails, :string
  end
end
