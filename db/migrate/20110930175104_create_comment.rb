class CreateComment < ActiveRecord::Migration
  def self.up
    create_table :comments,:force => true do |t|
      t.integer  :invoice_id
      t.string   :title
      t.text     :message
      t.string   :user_id
      t.string   :user_name
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
      drop_table :comments 
  end
end
