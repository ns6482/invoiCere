class CreateFeedback < ActiveRecord::Migration
  def self.up
    create_table :feedbacks, :force => true do |t|
      t.integer  :invoice_id
      t.string   :user_name
      t.string   :user_email
      t.integer  :rating
      t.text     :message
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
