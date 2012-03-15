class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string :date_format
      t.string :time_format
      t.string :number_format
      t.string :fiscal
      t.text :payment_stub
      t.number :discount
      t.decimal :shipping
      t.boolean :purchase_order_number
      t.boolean :email_alerts
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
