# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.auto_highlight = true
  navigation.items do |primary|
    #primary.item :view_invoice, "View #{@model}", invoice_path( @invoice), :if => Proc.new { can? :read, @invoice},  :link => {:remote => false}
    
    primary.item :show_invoice, "View #{@model}", invoice_path( @invoice), :if => Proc.new { can? :read, Invoice},  :link => {:class => 'interactive'}
    primary.item :deliveries_invoice, 'Emails', Proc.new {invoice_deliveries_path(@invoice)}, :if => Proc.new {can? :read, Delivery},  :link => {:class => 'interactive'}
    primary.item :payments_invoice, 'Payments', Proc.new {invoice_payments_path(@invoice)}, :if => Proc.new {can? :read, Payment and  @invoice.state !="draft"},  :link => {:class => 'interactive'}
    primary.item :comments_invoice, 'Comments', Proc.new {invoice_comments_path(@invoice)}, :if => Proc.new {can? :read, Comment}, :link => {:class => 'interactive'}
    
    
    primary.item :edit_invoice, "Edit #{@model}", edit_invoice_path( @invoice), :if => Proc.new { can? :update, @invoice and  @invoice.state != "paid"},  :link => {:remote => true}


    primary.item :print_invoice, "Print", invoice_path( @invoice)
    primary.item :pdf_invoice, "PDF", invoice_path( @invoice, :format => :pdf)
    primary.item :reminder_invoice, "Setup Reminder",edit_invoice_reminder_path(@invoice), :if => Proc.new { can? :update, @invoice.reminder},  :link => {:remote => true}
    primary.item :email_invoice, "Send Email",new_invoice_delivery_path(@invoice), :if => Proc.new { can? :create, Delivery},  :link => {:remote => true}
    primary.item :comment_invoice, "Add a Comment",new_invoice_comment_path(@invoice), :if => Proc.new { can? :create, Comment},  :link => {:remote => true}
    primary.item :copy_invoice, "Copy", new_invoice_path(:id => @invoice.id), :if => Proc.new { can? :create, @invoice}


    #primary.item :schedule_invoice, 'Setup Reocurrance', Proc.new {new_invoice_schedule_path( @invoice)}, :if => Proc.new { can? :update, Schedule and @invoice.schedule.nil?}, :link => {:remote => true}
    #primary.item :schedule_invoice, 'Edit Reocurrance', Proc.new {edit_invoice_schedule_path( @invoice)}, :if => Proc.new { can? :update, Schedule and !@invoice.schedule.nil?}, :link => {:remote => true, :class => 'schedule_icon'}
    
    primary.item :open_invoice, "Open Invoice",invoice_path(:id => @invoice.id, :commit => 'open'),:method => :put, :if => Proc.new {can? :update, @invoice and @invoice.state == "draft"},  :link => {:remote => true}
    primary.item :payment_invoice, "Log Payment",new_invoice_payment_path(@invoice), :if => Proc.new {can? :update, @invoice and @invoice.state == "open"},  :link => {:remote => true}#:class => 'interactive'}
    primary.item :draft_invoice, "Revert to Draft",invoice_path(:id => @invoice.id, :commit => 'revert_draft'),:method => :put, :if => Proc.new {can? :update, @invoice and @invoice.state == "open"},  :link => {:remote => true}
    primary.item :open_invoice, "Revert to Open",invoice_path(:id => @invoice.id, :commit => 'open_again'),:method => :put, :if => Proc.new {can? :update, @invoice and @invoice.state == "paid"},  :link => {:remote => true}

    primary.item :feedback_invoice, "Feedback on Invoice",new_invoice_payment_path(@invoice), :if => Proc.new {can? :create, @feedback and @invoice.state == "closed"},  :link => {:class => 'interactive'}

  end
   
end
