class UpdatePaymentAmountPrecision < ActiveRecord::Migration
  def self.up
        change_column :payments, :amount, :decimal, { :scale => 2, :precision => 12 }
  end

  def self.down
        change_column :payments, :amount, :decimal
  end
end
