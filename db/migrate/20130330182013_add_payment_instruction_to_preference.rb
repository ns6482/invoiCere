class AddPaymentInstructionToPreference < ActiveRecord::Migration
  def change
    add_column :preferences, :payment_instruction, :text
    add_column :preferences, :footer, :text
  end
end
