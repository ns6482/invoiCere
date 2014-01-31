module InvoicesHelper
  def link_to_btn(name, path, options = {})
    options[:class] ? options[:class] += ' btn btn-default' : options[:class] = 'btn btn-default'
    link_to(name, path, options)
  end
  
  def render_due_inv(inv)
    heading = "Due"
    if inv.class.name == "StandardInvoice"
      detail = current_company.preference.convert_date(inv.due_date)
    else 
      detail = current_company.preference.convert_date(@schedule.next_send + @schedule.due_on)
    end
    render_th(heading, detail)
  end
  
  

  def render_date_inv(inv)
    if inv.class.name == "StandardInvoice"
      heading = "Date"
      detail = current_company.preference.convert_date(inv.invoice_date).to_s.html_safe
    elsif inv.class.name == "ScheduleInvoice"
      heading = "Scheduled"
      detail = current_company.preference.convert_date(inv.next_send).to_s ||= "Not Yet"
    else
      heading = ""
      detail = ""
    end
    render_th(heading, detail)
  end
end