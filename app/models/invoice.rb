require 'transitions'

class Invoice < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  cattr_reader :per_page
  @@per_page = 10

  scope :none_scheduled,
    :conditions => "schedules.id IS NULL",
    :joins => ["LEFT JOIN 'schedules' ON invoices.id = schedules.invoice_id"]

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
      
  end

  belongs_to :client
  has_many :invoice_items, :dependent => :destroy
  has_one :schedule, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  #has_many :deliveries, :dependent => :destroy
  #has_many :comments, :dependent => :destroy  
  #has_many :feedbacks, :dependent => :destroy
  #has_one :reminder, :dependent => :destroy

  attr_protected :total_cost, :total_cost_inc_tax, :total_cost_inc_tax_delivery, :opened_date, :opened_by, :paid_date, :paid_by

  attr_accessor :company_id, :formatted_state, :update_user, :logo_url, :remaining_amount
  validates_presence_of :title,:invoice_date, :client_id
  validates_numericality_of :due_days
 
  accepts_nested_attributes_for :invoice_items, :reject_if => :all_blank, :allow_destroy => true
    
  before_save :set_due_date#, :update_invoice_totals
  after_save :update_invoice_totals
  after_create :setup_reminder

  def total_items
    self.invoice_items.sum(:qty).to_s
  end
  
  def _total_cost
    total = self.invoice_items.find(:all,:select => "SUM(qty*cost) as total_cost")
    @total = total.first.total_cost
  end


  def _total_cost_inc_tax

    if self.tax_rate.nil?
      tax = 1
    elsif self.tax_rate <=0
      tax = 1
    else
      tax =  ((self.tax_rate.to_f + 100)/100)
    end
    
    total_tax = self.invoice_items.find_all_by_taxable(true,:select => "SUM(qty*(cost*#{tax})) as total_cost")
    @total_tax = total_tax.first.total_cost.to_f
    @total_cost_inc_tax = @total_tax.to_f
    
    total = self.invoice_items.find_all_by_taxable([false, nil],:select => "SUM(qty*cost) as total_cost")
    @total_cost_no_tax = total.first.total_cost.to_f

    @total_cost_inc_tax = @total_cost_no_tax + @total_cost_inc_tax
    
  end

  def _total_cost_inc_tax_delivery
    self.delivery_charge.to_f + self._total_cost_inc_tax
  end

  def update_invoice_totals    
    self.total_cost = self._total_cost.to_f
    self.total_cost_inc_tax = self._total_cost_inc_tax
    self.total_cost_inc_tax_delivery = self._total_cost_inc_tax_delivery

    Invoice.update_all("total_cost = #{self.total_cost}, total_cost_inc_tax = #{self.total_cost_inc_tax}, total_cost_inc_tax_delivery = #{self.total_cost_inc_tax_delivery}","id=#{self.id}")

  end
  
  def formatted_state
    val = ""
    if state == "open" and due
      val = "Payment Due"
    elsif state == "draft"
      val = "Draft"
    elsif state == "open"
      val = "Open"
    else
      val = "Completed"
    end
    val
  end

  def remaining_amount

    total_payments = Payment.sum(:amount, :conditions => ['invoice_id = ?', self.id])
    
    val = self.total_cost_inc_tax_delivery

    if !total_payments.nil?
      val = val - total_payments    
    end
    self.remaining_amount = val
  end


  def clone_with_associations
    new_invoice = self.clone
    new_invoice.invoice_items = self.invoice_items

    #if !self.reminder.nil?
      #new_reminder = self.reminder.clone
      #new_reminder.invoice_id = self.id
      #new_invoice.reminder = new_reminder
    #end

    new_invoice.save!
    new_invoice
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
  
  def setup_reminder

    #Reminder.new do | reminder|
      #reminder.invoice_id = self.id
      #reminder.enabled = 0
      #reminder.default_message = 1
      #reminder.days_before= 3
      #reminder.frequency = "Weekly"

      #if self.due_days ==0
        #reminder.next_send  = self.due_date
      #else
        #reminder.next_send = (self.due_date-3) + 7
      #end
      
      #reminder.save!
    #end  
      
  end

  
end
