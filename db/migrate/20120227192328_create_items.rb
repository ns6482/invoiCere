class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :company_id
      t.string :name
      t.string :description
      t.string :unit
      t.decimal :price
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
