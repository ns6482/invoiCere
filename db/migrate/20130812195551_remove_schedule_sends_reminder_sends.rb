class RemoveScheduleSendsReminderSends < ActiveRecord::Migration
  def up
    drop_table :reminder_sends
    drop_table :schedule_sends
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
