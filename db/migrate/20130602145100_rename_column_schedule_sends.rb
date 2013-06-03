class RenameColumnScheduleSends < ActiveRecord::Migration

  def change
    rename_column :schedule_sends, :schedule_id, :schedule_invoice_id
  end

  
end
