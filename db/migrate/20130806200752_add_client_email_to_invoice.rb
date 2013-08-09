class AddClientEmailToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :client_email, :boolean
  end
end
