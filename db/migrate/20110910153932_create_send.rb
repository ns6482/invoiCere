class CreateSend < ActiveRecord::Migration
  def self.up
    create_table :sends, :force => true do |t|
      t.integer  :delivery_id
      t.integer  :contact_id
      t.string   :status
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :sends
  end
end
