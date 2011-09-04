class CreateScheduleSends < ActiveRecord::Migration
  def self.up
    create_table :schedule_sends, :force => true do |t|
      t.integer  :schedule_id
      t.integer  :contact_id
      t.string   :status
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :sends, :force => true do |t|
      t.integer  :delivery_id
      t.integer  :contact_id
      t.string   :status
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :schedule_sends
    drop_table :sends
  end
end
