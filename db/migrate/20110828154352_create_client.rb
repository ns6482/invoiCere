class CreateClient < ActiveRecord::Migration
  def self.up
    create_table :clients, :force => true do |t|
      t.string   :company_name
      t.string   :address1
      t.string   :address2
      t.string    :zip
      t.string   :city
      t.string   :country
      t.string   :phone
      t.string   :fax
      t.string   :email
      t.string   :contact_id
      t.integer  :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :clients    
  end
end
