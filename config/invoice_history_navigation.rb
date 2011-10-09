# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|    
   navigation.items do |primary|
    primary.item :show_invoice, "Invoice #{@model}", invoice_path( @invoice), :if => Proc.new { can? :read, Invoice},  :link => {:class => 'interactive'}
    primary.item :deliveries_invoice, 'Emails', Proc.new {invoice_deliveries_path(@invoice)}, :if => Proc.new {can? :read, Delivery},  :link => {:class => 'interactive'}
    primary.item :payments_invoice, 'Payments', Proc.new {invoice_payments_path(@invoice)}, :if => Proc.new {can? :read, Payment and  @invoice.state !="draft"},  :link => {:class => 'interactive'}
    primary.item :comments_invoice, 'Comments', Proc.new {invoice_comments_path(@invoice)}, :if => Proc.new {can? :read, Comment}, :link => {:class => 'interactive'}   
    primary.dom_class = 'navigation'
   end  
end
