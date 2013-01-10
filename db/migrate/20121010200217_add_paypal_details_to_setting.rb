class AddPaypalDetailsToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :paypal_login, :string
    add_column :settings, :paypal_sig, :string
    add_column :settings, :paypal_pwd, :string
    add_column :settings, :paypal_enabled, :string
  end
end
