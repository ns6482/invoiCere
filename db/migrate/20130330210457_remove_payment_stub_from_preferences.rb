class RemovePaymentStubFromPreferences < ActiveRecord::Migration
  def up
    remove_column :preferences, :payment_stub
  end

  def down
    add_column :preferences, :payment_stub, :string
  end
end
