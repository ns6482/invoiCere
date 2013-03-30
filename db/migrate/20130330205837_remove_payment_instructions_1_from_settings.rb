class RemovePaymentInstructions1FromSettings < ActiveRecord::Migration
  def up
    remove_column :settings, :payment_instructions_1
  end

  def down
    add_column :settings, :payment_instructions_1, :string
  end
end
