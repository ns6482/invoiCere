# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.auto_highlight = false
  navigation.items do |primary|
    
    primary.item :edit_invoice, "Edit #{@model}", edit_invoice_path( @model), :if => Proc.new { can? :update, @invoice and  @invoice.state == "draft"},  :link => {:remote => true}


    primary.item :print_invoice, "Print", invoice_path( @model)
    primary.item :pdf_invoice, "PDF", invoice_path( @model, :format => :pdf)
    #primary.item :reminder_invoice, "Setup Reminder",edit_invoice_reminder_path(@invoice), :if => Proc.new { can? :update, @invoice.reminder},  :link => {:class => 'interactive'}
    #primary.item :email_invoice, "Send Email",new_invoice_delivery_path(@invoice), :if => Proc.new { can? :create, Delivery},  :link => {:class => 'interactive'}
    #primary.item :comment_invoice, "Add a Comment",new_invoice_comment_path(@invoice), :if => Proc.new { can? :create, Comment},  :link => {:class => 'interactive'}
    primary.item :copy_invoice, "Copy", new_invoice_path(:id => @invoice.id), :if => Proc.new { can? :create, @invoice}#,  :link => {:class => 'interactive'}


    #primary.item :schedule_invoice, 'Setup Reocurrance', Proc.new {new_invoice_schedule_path( @invoice)}, :if => Proc.new { can? :update, Schedule and @invoice.schedule.nil?}, :link => {:class => 'interactive'}
    #primary.item :schedule_invoice, 'Edit Reocurrance', Proc.new {edit_invoice_schedule_path( @invoice)}, :if => Proc.new { can? :update, Schedule and !@invoice.schedule.nil?}, :link => {:class => 'interactive schedule_icon'}
    
    primary.item :open_invoice, "Open Invoice",invoice_path(:id => @invoice.id, :commit => 'complete'),:method => :put, :if => Proc.new {can? :update, @invoice and @invoice.state == "draft"},  :link => {:remote => true}#:class => 'interactive'}
    primary.item :payment_invoice, "Log Payment",new_invoice_payment_path(@invoice), :if => Proc.new {can? :update, @invoice and @invoice.state == "open"},  :link => {:remote => true}#:class => 'interactive'}
    primary.item :draft_invoice, "Revert to Draft",invoice_path(:id => @invoice.id, :commit => 'draft'),:method => :put, :if => Proc.new {can? :update, @invoice and @invoice.state == "open"},  :link => {:remote => true}#:class => 'interactive'}

    #primary.item :feedback_invoice, "Feedback on Invoice",new_invoice_payment_path(@invoice), :if => Proc.new {can? :create, @feedback and @invoice.state == "closed"},  :link => {:class => 'interactive'}

  end
   
end
