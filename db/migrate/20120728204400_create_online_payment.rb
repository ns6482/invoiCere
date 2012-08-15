class CreateOnlinePayment < ActiveRecord::Migration
  def self.up    
    add_column :payments, :reference, :string
    add_column :payments, :status, :string
  end

  def self.down
    remove_column :payments, :reference
    remove_column :payments, :status
  end
end
