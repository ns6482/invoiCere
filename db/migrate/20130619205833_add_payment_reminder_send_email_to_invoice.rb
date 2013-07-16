class AddPaymentReminderSendEmailToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :payment_reminder, :boolean
    add_column :invoices, :send_email, :boolean
  end
end
