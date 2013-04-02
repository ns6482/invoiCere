class AddSecretIdToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :secret_id, :string
  end
end
