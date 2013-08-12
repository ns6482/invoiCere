class AddSendableTypeToSends < ActiveRecord::Migration
  def change
    #add_column :sends, :sendable_type, :string 
    add_column :sends, :sendable_id, :integer
  end
end
