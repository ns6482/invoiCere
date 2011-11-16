module DashboardsHelper
  def invoices_chart_series(invoices, start_time)
      invoices_by_day = invoices.where(:invoice_date => start_time.beginning_of_day..Time.zone.now.end_of_day).
                      group("date(invoice_date)").
                      select("invoice_date, sum(total_cost_inc_tax_delivery) as total_invoice, count(*) as num_invoice")
      (start_time.to_date..Date.today).map do |date|
        invoice = invoices_by_day.detect { |invoice| invoice.invoice_date.to_date == date }
        invoice && invoice.total_invoice.to_f || 0 
      end.inspect
    end
end
