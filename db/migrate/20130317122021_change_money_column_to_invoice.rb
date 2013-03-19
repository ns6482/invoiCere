class ChangeMoneyColumnToInvoice < ActiveRecord::Migration
  
  def self.up
    change_table :invoices do |i|
      i.change :total_cost, :integer
      i.change  :delivery_charge, :integer
      i.change  :total_cost_inc_tax, :integer
      i.change  :total_cost_inc_tax_delivery, :integer  
      i.change :due_amount, :integer
    end
    
    change_table :invoice_items do |i|
      i.change :cost, :integer
    end   
    
    change_table :payments do |i|
      i.change :amount, :integer
    end   

    change_table :schedules do |s|
      s.change :late_fee, :integer
      s.change :delivery_charge, :integer
    end
    
    change_table :schedule_items do |si|
      si.change :cost, :integer
    end

    
  end
 
  def self.down
    change_table :invoices do |i|
      i.change :total_cost, :decimal
      i.change  :delivery_charge, :decimal
      i.change  :total_cost_inc_tax, :decimal
      i.change  :total_cost_inc_tax_delivery, :decimal
      i.change  :due_amount, :decimal
      
    end   
    
    change_table :invoice_items do |i|
      i.change :cost, :decimal
    end   
    
    
    change_table :payments do |i|
      i.change :amount, :decimal
    end   
    
    change_table :schedules do |s|
      s.change :late_fee, :decimal
      s.change :delivery_charge, :decimal
      
    end
    
    change_table :schedule_items do |si|
      si.change :cost, :decimal
    end

    
  end
  
end
