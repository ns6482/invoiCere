require 'transitions'

class StandardInvoice < Invoice
  include ActiveRecord::Transitions
  
  validates_presence_of :title,:invoice_date
  validates_numericality_of :due_days
   
  state_machine do
    state :draft # first one is initial state
    state :open, :enter=> :update_opened_date
    state :paid, :enter => :update_paid_date 

    event :open do
      transitions :to => :open, :from => [:draft]
    end

    event :pay do
      transitions :to => :paid, :from => [:open]
    end 
    
    event :revert_draft do 
      transitions :to => :draft, :from => [:open], :on_transition => :clear_all_payments
    end
    
    event :open_again do 
      transitions :to => :open, :from => [:paid] , :on_transition => :clear_all_payments
    end
    
      
  end

  
    
  before_save :set_due_date#, :update_invoice_totals
  after_create :setup_reminder, :setup_secret_id

 
  def remaining_amount
    
    total_payments = Payment.sum(:amount, :conditions => "invoice_id = #{self.id} and status = 'paid'")
    
    val = self.total_cost_inc_tax_delivery

    if !total_payments.nil?
      val = val - total_payments    
    end
    
    val#.round(2)
    
  end
  
   def formatted_state
    val = ""
    if state == "open" and due
      val = "Due"
    elsif state == "draft"
      val = "Draft"
    elsif state == "open"
      val = "Open"
    else
      val = "Completed"
    end
    val
  end
  
   def formatted_state_badge
    val = ""
    if state == "open" and due
      val = "badge-important"
    elsif state == "draft"
      val = "badge-info"
    elsif state == "open"
      val = "badge-success"
    end
    
    val
  end




  private
  
 

  def update_opened_date
    self.opened_date = Date.today
    self.opened_by = @update_user
  end

  def update_paid_date
    self.paid_date = Date.today
    self.paid_by = @update_user
  end

  def set_due_date    
    self.due_date = self.invoice_date + self.due_days
  end
  
  def due
    if self.due_date.nil?
      val = false
    else
      val = self.due_date <= Date.today
    end
    
    val
  end
 
 
  def clear_all_payments
    Payment.delete_all(:invoice_id => self.id)
  end
  
  def setup_reminder

    Reminder.new do | reminder|
      reminder.invoice_id = self.id
      reminder.enabled = 0
      reminder.default_message = 1
      reminder.days_before= 3
      reminder.frequency = "Weekly"

      if self.due_days ==0
        reminder.next_send  = self.due_date
      else
        reminder.next_send = (self.due_date-3) + 7
      end
      
      reminder.save!
    end  
      
  end
  
  def setup_secret_id
    self.update_attribute(:secret_id, SecureRandom.urlsafe_base64)
  end
  
   def setup_secret_id
    self.update_attribute(:secret_id, SecureRandom.urlsafe_base64)
  end

  
   
end
