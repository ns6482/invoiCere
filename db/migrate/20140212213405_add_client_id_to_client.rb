class AddClientIdToClient < ActiveRecord::Migration
  def change
    add_column :clients, :business_id, :string
  end
end
