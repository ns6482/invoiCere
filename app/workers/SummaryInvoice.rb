
class SummaryInvoice
  @queue = :summaries_queue
  
  
  def self.perform(invoice_id)
      
      
      #i = Invoice.find(invoice_id)
      #s = Summary.find_by_client_id(i.client_id) || Summmary.new(client_id: i.client_id)
      
    ActiveRecord::Base.connection.execute("INSERT INTO summaries (client_id, company_id, currency, yr, mo, tax_year) 
     SELECT DISTINCT clients.id, clients.company_id, invoices.currency , year(invoices.opened_date), month(invoices.opened_date), year(dates.start_date)
     FROM clients 
     JOIN invoices ON clients.id = invoices.client_id  
     INNER JOIN (
               select company_id
                , str_to_date (
                CONCAT(
                  preferences.fiscal_start
                  , case when month(curdate()) < cast(right(fiscal_start,2) as UNSIGNED) = 0 then 
                    year(curdate())
                    else
                      year(curdate())-1
                    end 
                ), '%d%m%Y') as  start_date
                
               
                  , str_to_date (
                   CONCAT(
                      preferences.fiscal_end
                    , case when month(curdate()) > cast(right(fiscal_end,2) as UNSIGNED) then 
                    year(curdate()) +1
                    else
                      year(curdate())
                    end 
                    ), '%d%m%Y')  as end_date
                
                
               from preferences    
     )  dates ON clients.company_id = dates.company_id
     LEFT JOIN summaries 
      ON clients.id = summaries.client_id 
      AND invoices.currency = summaries.currency
      AND year(invoices.opened_date) = summaries.yr
      AND month(invoices.opened_date) = summaries.mo
     WHERE summaries.client_id IS NULL
     AND invoices.type = 'StandardInvoice'
     AND invoices.opened_Date IS NOT NULL
     AND invoices.id = #{invoice_id}")
    
    ActiveRecord::Base.connection.execute(" UPDATE 
     summaries s 
     LEFT JOIN ( 
     SELECT clients.company_id
     , clients.id
     , invoices.currency
     , year(invoices.opened_date) as yr 
     , month(invoices.opened_date) as mo
     , year(dates.start_date) as tax_year
     , COALESCE(MIN(CASE WHEN invoices.state = 'open' THEN invoices.due_date ELSE NULL END),0) AS min_due_date
     , COALESCE(SUM(payments.amount),0) AS total_payments
     , COALESCE(SUM(CASE WHEN invoices.state = 'open' THEN total_cost_inc_tax_delivery ELSE 0 END),0) AS total_amount_open
     , COALESCE(SUM(CASE WHEN invoices.state = 'open' THEN invoices.due_amount ELSE 0 END),0) AS total_due
     , COALESCE(COUNT(DISTINCT(CASE WHEN invoices.state = 'open' AND invoices.due_amount > 0 THEN invoices.id ELSE NULL END)),0) AS count_due
     , COALESCE(COUNT(DISTINCT(CASE WHEN invoices.state = 'open' THEN invoices.id ELSE NULL END)),0) AS count_invoices_open
     , COALESCE(COUNT(DISTINCT(CASE WHEN invoices.state = 'draft' THEN invoices.id ELSE NULL END)),0) AS count_invoices_draft
     , COALESCE(SUM(CASE WHEN invoices.state = 'closed' THEN total_cost_inc_tax_delivery ELSE 0 END),0) AS total_amount_closed
     , COALESCE(COUNT(DISTINCT(CASE WHEN invoices.state = 'closed' THEN invoices.id ELSE NULL END)),0) AS count_invoices_closed
     FROM clients
      INNER JOIN invoices ON invoices.client_id = clients.id 
      INNER JOIN (
               select company_id
                , str_to_date (
                CONCAT(
                  preferences.fiscal_start
                  , case when month(curdate()) < cast(right(fiscal_start,2) as UNSIGNED) = 0 then 
                    year(curdate())
                    else
                      year(curdate())-1
                    end 
                ), '%d%m%Y') as  start_date
                
               
                  , str_to_date (
                   CONCAT(
                      preferences.fiscal_end
                    , case when month(curdate()) > cast(right(fiscal_end,2) as UNSIGNED) then 
                    year(curdate()) +1
                    else
                      year(curdate())
                    end 
                    ), '%d%m%Y')  as end_date
                
                
               from preferences    
            )  dates ON clients.company_id = dates.company_id
      LEFT OUTER JOIN payments ON payments.invoice_id = invoices.id and payments.status = 'paid' 
      AND payments.created_at BETWEEN dates.start_date and dates.end_date 
     WHERE invoices.id =  #{invoice_id}
     AND type = 'StandardInvoice'
     AND invoices.opened_date BETWEEN dates.start_date and dates.end_date
     GROUP BY clients.id, clients.company_id, invoices.currency, year(invoices.opened_date), month(invoices.opened_date)
     ) t ON s.company_id = t.company_id 
     AND s.client_id = t.id
     AND s.currency = t.currency
     AND s.yr = t.yr
     AND s.mo = t.mo
     AND s.tax_year = t.tax_year
    
    SET 
     s.total_due = t.total_due
     , s.count_due = t.count_due
     , s.total_payments = t.total_payments
     , s.total_amount_open = t.total_amount_open
     , s.total_amount_closed = t.total_amount_closed
     , s.count_invoices_open = t.count_invoices_open
     , s.count_invoices_closed = t.count_invoices_closed
     , s.count_invoices_draft = t.count_invoices_draft
     , s.min_due_date = t.min_due_date

    ")
  end
  
end









