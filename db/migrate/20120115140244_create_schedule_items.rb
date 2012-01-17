class CreateScheduleItems < ActiveRecord::Migration
  
  def self.up
    create_table :schedule_items, :force => true do |t|
      t.integer  :schedule_id, :null => false
      t.string   :item_type,        :limit => 20,  :null => false
      t.string   :item_description, :limit => 100, :null => false
      t.decimal  :qty,                             :null => false
      t.decimal  :cost,                            :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean  :taxable
    end

  end

  def self.down
    drop_table :schedule_items  
  end

  
end
