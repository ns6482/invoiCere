class CreateRoles < ActiveRecord::Migration
  def self.up
      create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end

  def self.down
         drop_table "roles"
  end
end
