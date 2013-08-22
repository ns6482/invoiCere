class CreateSubscriptions < ActiveRecord::Migration

  def self.up
    create_table :subscriptions do |t|
      t.integer :company_id
      t.string :paymill_id
      t.integer :plan_id
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
  
end