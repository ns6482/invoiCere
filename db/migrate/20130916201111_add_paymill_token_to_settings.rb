class AddPaymillTokenToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :paymill_public_key, :string
    add_column :settings, :paymill_enabled, :string
  end
end
