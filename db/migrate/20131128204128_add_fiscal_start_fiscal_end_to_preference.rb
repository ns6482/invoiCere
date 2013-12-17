class AddFiscalStartFiscalEndToPreference < ActiveRecord::Migration
  def change
    add_column :preferences, :fiscal_start, :string
    add_column :preferences, :fiscal_end, :string
  end
end
