require 'transitions'

class Invoice < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  liquid_methods :title

  cattr_reader :per_page
  @@per_page = 10


  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_blank => true, :allow_nil => true  
    
  scope :for_year,
    :select => "invoices.*",
    :conditions => "invoice_date between '#{Date.new(Date.today.year,1,1)}' and '#{Date.new(Date.today.year+1,1,1)}'",
    :readonly => false
  
  scope :by_date, lambda { |time1, time2 | 
    where("invoice_date >= ? and invoice_date < ? ", time1, time2) 
  }
  
  scope :ytd, by_date( Date.new(Date.today.year,1,1) , Date.today+1)
  scope :mtd, by_date( Date.new(Date.today.year,Date.today.month,1) , Date.today)
  
  #scope :group_by_month, 
    #:select => "invoices.mm as month, SUM(invoices.total_cost_inc_tax_delivery) AS val, COUNT(*) AS count_invoices", 
    #:group => "mm"
  
  #scope :group_by_day, 
    #:select => "invoices.dd as day, SUM(invoices.total_cost_inc_tax_delivery) AS val, COUNT(*) AS count_invoices", 
    #:group => "dd" 
   
  #scope :last_12_months, by_date(Date.today << 12, Date.today).group_by_month
  #scope :last_3_months, by_date(Date.today << 12, Date.today).group_by_day
  #scope :last_month, by_date(Date.today << 12, Date.today).group_by_day


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

  belongs_to :client
  has_many :invoice_items, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  has_many :deliveries, :dependent => :destroy
  has_many :comments, :dependent => :destroy  
  has_many :feedbacks, :dependent => :destroy
  has_one :reminder, :dependent => :destroy

  attr_protected :total_cost, :total_cost_inc_tax, :total_cost_inc_tax_delivery, :opened_date, :opened_by, :paid_date, :paid_by

  attr_accessor :company_id, :formatted_state, :update_user, :logo_url, :remaining_amount
  validates_presence_of :title,:invoice_date, :client_id
  validates_numericality_of :due_days
 
  accepts_nested_attributes_for :invoice_items, :reject_if => :all_blank, :allow_destroy => true
    
  before_save :set_due_date#, :update_invoice_totals
  after_save :update_invoice_totals
  after_create :setup_reminder

  def total_items
    self.invoice_items.sum(:qty)
  end
  
  def _total_cost
    total = self.invoice_items.find(:all,:select => "SUM(qty*cost) as total_cost")
    @total = discountize(total.first.total_cost)    
  end


  def _total_cost_inc_tax

    if self.tax_rate.nil?
      tax = 1
    elsif self.tax_rate <=0
      tax = 1
    else
      tax =  ((self.tax_rate + 100)/100)
    end
    
    total_tax = self.invoice_items.find_all_by_taxable(true,:select => "SUM(qty*(cost*#{tax})) as total_cost")
    @total_tax = total_tax.first.total_cost.to_f
    @total_cost_inc_tax = @total_tax.to_f
    
    total = self.invoice_items.find_all_by_taxable([false, nil],:select => "SUM(qty*cost) as total_cost")
    @total_cost_no_tax = total.first.total_cost.to_f

    @total_cost_inc_tax = @total_cost_no_tax + @total_cost_inc_tax
    discountize(@total_cost_inc_tax)
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
    
    total_payments = Payment.sum(:amount, :conditions => "invoice_id = #{self.id} and status <> 'cancelled'")
    
    val = self.total_cost_inc_tax_delivery

    if !total_payments.nil?
      val = val - total_payments    
    end
    self.remaining_amount = val.round(2)
    
  end



  private
  
  def discountize(val)
    
    if !self.discount.nil? and self.discount != "" #and !val.nil?

      discount_calc= self.discount.gsub(/\%/, "").to_f
 
      if self.discount.include? "%"
        val = val - (val * (discount_calc/100))
      else
        val = val - discount_calc
      end
    
    end
    
    val
  end

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
  
  def readonly?
    false
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
      
end
