class CreateSummary < ActiveRecord::Migration
  def change
        create_table :summaries do |t|

          t.integer :company_id
          t.integer :client_id
          t.string :currency
          t.integer :total_due
          t.integer :total_amount_open
          t.integer :total_amount_closed
          t.integer :total_payments
          t.integer :count_invoices_open
          t.integer  :count_due
          t.integer :count_invoices_due
          t.integer :count_invoices_closed
          t.integer :count_invoices_draft
          t.datetime :min_due_date
          t.integer :yr
          t.integer :mo
          t.integer :tax_year
      
                    
    end
  end
end


       