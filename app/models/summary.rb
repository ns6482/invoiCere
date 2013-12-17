class Summary < ActiveRecord::Base
  belongs_to :company
  belongs_to :clients
  
  attr_protected :company_id
  
  scope :by_currency,
  :select => "currency
    , SUM(total_amount_open) AS total_amount_open
    , SUM(total_due) AS total_due
    , SUM(count_due) AS count_due
    , SUM(count_invoices_open) AS count_invoices_open
    , SUM(count_invoices_draft) AS count_invoices_draft
    , SUM(total_amount_closed) AS total_amount_closed
    , SUM(count_invoices_closed) AS count_invoices_closed
    , SUM(total_payments) AS total_payments",
  :group => "currency"
  
  
   scope :by_client_currency,
  :select => "currency, client_id, clients.company_name
    , SUM(total_amount_open) AS total_amount_open
    , SUM(total_due) AS total_due
    , SUM(count_due) AS count_due
    , SUM(count_invoices_open) AS count_invoices_open
    , SUM(count_invoices_draft) AS count_invoices_draft
    , SUM(total_amount_closed) AS total_amount_closed
    , SUM(count_invoices_closed) AS count_invoices_closed
    , SUM(total_payments) AS total_payments",
  :joins => "INNER JOIN clients on clients.id = client_id",
  :group => " client_id, clients.company_name"
  
  
  scope :by_yr_mo, by_currency.select("yr, mo").group("yr, mo")
 

  
end
