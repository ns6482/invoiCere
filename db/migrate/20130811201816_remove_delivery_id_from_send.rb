class RemoveDeliveryIdFromSend < ActiveRecord::Migration
  def up
    remove_column :sends, :delivery_id
  end

  def down
    add_column :sends, :delivery_id, :integer
  end
end
