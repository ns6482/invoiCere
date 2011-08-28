class CreateContact < ActiveRecord::Migration
  def self.up
    create_table :contacts, :force => true do |t|
      t.string   :title
      t.string   :first_name
      t.string   :last_name
      t.string   :job_title
      t.string   :email
      t.string   :phone
      t.string   :mobile
      t.string   :fax
      t.string   :client_id
      t.timestamps
    end

  end

  def self.down
  end
end
