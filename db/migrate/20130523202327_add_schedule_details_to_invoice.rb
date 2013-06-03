class AddScheduleDetailsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :name, :string
    add_column :invoices, :frequency, :integer
    add_column :invoices, :frequency_type, :string
    add_column :invoices, :last_sent, :date
    add_column :invoices, :next_send, :date
    add_column :invoices, :due_on, :integer
    add_column :invoices, :end_date, :date
    add_column :invoices, :enabled, :integer
    add_column :invoices, :send_to_client, :integer
    add_column :invoices, :message, :text
    add_column :invoices, :default_message, :integer
    add_column :invoices, :custom_message, :text
    add_column :invoices, :format, :integer
    add_column :invoices, :draft_only, :boolean
    add_column :invoices, :base_request, :string
    add_column :invoices, :type, :string

  end
end


