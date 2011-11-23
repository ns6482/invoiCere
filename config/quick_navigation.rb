# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  

  navigation.items do |primary|    
    primary.item :new_invoice, 'New Invoice', new_invoice_path, :if => Proc.new { can? :create, Invoice},  :link => {:class => 'quick'}
    primary.item :new_client, 'New Client', new_client_path, :if => Proc.new { can? :create, Client},  :link => {:class => '    quick'}
    primary.dom_class = 'quick-navigation'
  end
  

end
