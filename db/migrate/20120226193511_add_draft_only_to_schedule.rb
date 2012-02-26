class AddDraftOnlyToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :draft_only, :boolean
  end

  def self.down
    remove_column :schedules, :draft_only
  end
end
