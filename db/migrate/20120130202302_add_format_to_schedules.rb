class AddFormatToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :format, :integer
  end

  def self.down
    remove_column :schedules, :format
  end
end
