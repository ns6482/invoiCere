class AddExtrasToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :owner, :boolean,  :default => false
    add_column :users, :name, :string
    add_column :users, :client_id, :integer
  end

  def self.down
    remove_column :users, :company_id
    remove_column :users, :owner
    remove_column :users, :name
    remove_column :users, :client_id
  end
end
