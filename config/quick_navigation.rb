# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  

  navigation.items do |primary|    
    #primary.item :new_invoice, 'Invoice', new_invoice_path, :if => Proc.new { can? :create, Invoice},  :link => {:class => 'button'}
    primary.item :new_client, 'Client', new_client_path, :if => Proc.new { can? :create, Client},  :link => {:class => 'button'}
    primary.dom_class = 'quick-navigation'
  end
  

end
