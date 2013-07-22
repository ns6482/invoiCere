class CreateTableReminderSends < ActiveRecord::Migration
 def self.up
    create_table :reminder_sends, :force => true do |t|
      t.integer  :reminder_id
      t.integer  :contact_id
      t.string   :status
      t.datetime :created_at
      t.datetime :updated_at
    end

  end

  def self.down
    drop_table :reminder_sends
  end
end
