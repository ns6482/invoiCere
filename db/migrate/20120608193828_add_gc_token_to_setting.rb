class AddGcTokenToSetting < ActiveRecord::Migration
  def self.up
    add_column :settings, :pay_gc_token, :string
    add_column :settings, :pay_gc_enabled, :integer
  end

  def self.down
    remove_column :settings, :pay_gc_enabled
    remove_column :settings, :pay_gc_token
  end
end
