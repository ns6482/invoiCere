
class SummaryInvoice
  @queue = :summaries_queue
  
  
  def self.perform(invoice_id)
      
      
      i = Invoice.find(invoice_id)
      #s = Summary.find_by_client_id(i.client_id) || Summmary.new(client_id: i.client_id)
          
    ActiveRecord::Base.connection.execute("INSERT INTO summaries (client_id, company_id, currency) 
      SELECT DISTINCT clients.id, clients.company_id, invoices.currency 
      FROM clients 
      JOIN invoices ON clients.id = invoices.client_id 
      LEFT JOIN summaries ON clients.id = summaries.client_id AND invoices.currency = summaries.currency
      WHERE summaries.client_id IS NULL
      AND clients.id = #{i.client_id}")
    
    ActiveRecord::Base.connection.execute("UPDATE summaries  s 

    INNER JOIN ( 
    
      SELECT clients.company_id
        , clients.id
        , invoices.currency
        , MIN(CASE WHEN invoices.state = 'open' THEN invoices.due_date ELSE NULL END) AS min_due_date
        , SUM(CASE WHEN invoices.state = 'open' THEN total_cost_inc_tax_delivery ELSE 0 END) AS total_amount_open
        , SUM(CASE WHEN invoices.state = 'open' THEN invoices.due_amount ELSE 0 END) AS total_due
        , COUNT(DISTINCT(CASE WHEN invoices.state = 'open' THEN invoices.id ELSE NULL END)) AS count_invoices_open
        , COUNT(DISTINCT(CASE WHEN invoices.state = 'draft' THEN invoices.id ELSE NULL END)) AS count_invoices_draft
        , SUM(CASE WHEN invoices.state = 'closed' THEN total_cost_inc_tax_delivery ELSE 0 END) AS total_amount_closed
        , COUNT(DISTINCT(CASE WHEN invoices.state = 'closed' THEN invoices.id ELSE NULL END)) AS count_invoices_closed
      FROM clients 
      LEFT OUTER JOIN invoices ON invoices.client_id = clients.id
      WHERE clients.id =   #{i.client_id}
      GROUP BY clients.id, clients.company_id, invoices.currency
    ) t ON s.company_id = t.company_id    
     AND s.client_id = t.id
     AND s.currency = t.currency
    SET 
       s.total_due = t.total_due
      , s.total_amount_open = t.total_amount_open
      , s.total_amount_closed = t.total_amount_closed
      , s.count_invoices_open = t.count_invoices_open
      , s.count_invoices_closed = t.count_invoices_closed
      , s.count_invoices_draft = t.count_invoices_draft
      , s.min_due_date = t.min_due_date"
    )
  end
  
end
