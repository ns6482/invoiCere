require 'transitions'

class Invoice < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :business_id, use: :slugged
  
  liquid_methods :title

  cattr_reader :per_page
  
  attr_accessible :payables
  
  @@per_page = 10

  validates_presence_of :business_id
  validates_uniqueness_of :business_id
  
  validates_format_of :discount, :with => /^((0*?\.\d+(\.\d{1,2})?)|((\d+(\.\d{1,2})?)|(((100(?:\.0{1,2})?|0*?\.\d{1,2}|\d{1,2}(?:\.\d{1,2})?)\%))))$/, :message=> "must be a positive numerical or percentage value, maximum two decimal places allowed", :allow_blank => true, :allow_nil => true  
    
  validates_format_of :emails, :with => /^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$/,  :unless => Proc.new {|i| i.emails.blank?}
  
  scope :for_year,
    :select => "invoices.*",
    :conditions => "invoice_date between '#{Date.new(Date.today.year,1,1)}' and '#{Date.new(Date.today.year+1,1,1)}'",
    :readonly => false
  
  scope :by_date, lambda { |time1, time2 | 
    where("invoice_date >= ? and invoice_date < ? ", time1, time2) 
  }
  
  scope :ytd, by_date( Date.new(Date.today.year,1,1) , Date.today+1)
  scope :mtd, by_date( Date.new(Date.today.year,Date.today.month,1) , Date.today)
  scope :open, -> { where state: 'open' }  
 
  belongs_to :client
  belongs_to :user
  
  has_many :invoice_items, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  has_many :deliveries, :dependent => :destroy
  has_many :comments, :dependent => :destroy  
  has_many :feedbacks, :dependent => :destroy
  has_one :reminder, :dependent => :destroy
  #has_and_belongs_to_many :payables, :autosave => true


  accepts_nested_attributes_for :invoice_items, :reject_if => :all_blank, :allow_destroy => true

  attr_protected :total_cost, :total_cost_inc_tax, :total_cost_inc_tax_delivery, :opened_date, :opened_by, :paid_date, :paid_by, :secret_id

  attr_accessor :company_id, :formatted_state, :update_user, :logo_url, :remaining_amount
  validates_presence_of :client_id
      
  after_save :update_invoice_totals


  monetize :delivery_charge, :as => "delivery_charge_cents"
  monetize :total_cost, :as => "total_cost_cents"
  monetize :total_cost_inc_tax, :as => "total_cost_inc_tax_cents"
  monetize :total_cost_inc_tax_delivery, :as => "total_cost_inc_tax_delivery_cents"
  monetize :remaining_amount, :as => "remaining_amount_cents"
  monetize :late_fee, :as => "late_fee_cents"
  
  PAYABLES = %w[Paypal GoCardless Paymill]
  PAYABLES_VIEW = [["Paypal","Paypal"], ["GoCardless","GoCardless"], ["Paymill","Paymill"]]
  INVOICE_STATES_VIEW = {:draft => "default",  :open => "danger",   :closed => "success"}


  def payables=(payables)
    self.payables_mask = (payables & PAYABLES).map { |r| 2**PAYABLES.index(r) }.inject(0, :+)
  end

  def payables
    PAYABLES.reject do |r|
      ((payables_mask || 0) & 2**PAYABLES.index(r)).zero?
    end
  end
  
  def can_pay_through?(payable)
    payables.include?(payable.to_s) or payable == "Manual"
  end
  
  def total_items
    self.invoice_items.sum(:qty)
  end
  
  def _total_cost
    total = self.invoice_items.find(:all,:select => "SUM(qty*cost) as total_cost")
    @total = total.first.total_cost.to_i    
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
    @total_tax = total_tax.first.total_cost.to_i
    @total_cost_inc_tax = @total_tax.to_i
    
    total = self.invoice_items.find_all_by_taxable([false, nil],:select => "SUM(qty*cost) as total_cost")
    @total_cost_no_tax = total.first.total_cost.to_i

    @total_cost_inc_tax = @total_cost_no_tax + @total_cost_inc_tax
    #@total_cost_inc_tax = discountize(@total_cost_inc_tax).to_i
  end

  def _total_cost_inc_tax_delivery
    self.delivery_charge.to_i + discountize(self._total_cost_inc_tax).to_i
  end

  def update_invoice_totals    
    self.total_cost = self._total_cost.to_i
    self.total_cost_inc_tax = self._total_cost_inc_tax.to_i
    self.total_cost_inc_tax_delivery = self._total_cost_inc_tax_delivery.to_i

    Invoice.update_all("total_cost = #{self.total_cost}, total_cost_inc_tax = #{self.total_cost_inc_tax}, total_cost_inc_tax_delivery = #{self.total_cost_inc_tax_delivery}","id=#{self.id}")
  end
  

  def discounted_value
    
    val =0
    
    if !self.discount.nil? and self.discount != "" and !val.nil?
  
      discount_calc= self.discount.gsub(/\%/, "")
  
      if self.discount.include? "%"
        val = self.total_cost_inc_tax
        val =  (((val.to_d * (discount_calc.to_d/100).to_d))/100).to_d
      end
      
    end if
    
    val
  end
  
  
 


  private
  
  def discountize(val)
    
    if !self.discount.nil? and self.discount != "" #and !val.nil?
        discount_calc= self.discount.gsub(/\%/, "") 

 
      if self.discount.include? "%"
        val =  (val.to_d  - (val.to_d * (discount_calc.to_d/100).to_d)).to_i
      else
        val = (val.to_d) - (discount_calc.to_d*100)
      end
    
    end
    
    val
  end

    
  def readonly?
    false
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Invoice.model_name
        #Invoice.model_name
      end
    end
    super
  end
  
 
  
  def self.to_csv(all_invoices)
    CSV.generate do |csv|
      csv << ["id", "business id", "created at", "invoice date", "title", "notes", "tax rate", "delivery_charge", "purchase order id", "status", "late fee", "due days", "total cost", "total cost including delivery and tax", "due date", "opened date", "opened_by", "paid date", "paid by", "cancelled", "cancelled date", "cancelled by", "discount", "currency", "item id", "item description", "item quantity", "item cost", "item taxable", "item created at"]
      all_invoices.each do |inv|
        csv << [inv.id, inv.business_id, inv.created_at, inv.invoice_date, inv.title, inv.notes, inv.tax_rate, inv.delivery_charge, inv.purchase_order_id, inv.state, inv.late_fee, inv.due_days, inv.total_cost, inv.total_cost_inc_tax_delivery, inv.due_date,  inv.opened_date, inv.opened_by, inv.paid_date, inv.paid_by, inv.cancelled, inv.cancelled_date, inv.cancelled_by, inv.discount, inv.currency, inv.invoice_items.first.id, inv.invoice_items.first.item_description, inv.invoice_items.first.qty, inv.invoice_items.first.cost, inv.invoice_items.first.taxable, inv.invoice_items.first.created_at]
        if inv.invoice_items.count > 1
          counter = 0
          inv.invoice_items.each do |item|
            if counter != 0 then
              csv << ["","","","","","","","","","","","","","","","","","","","","","", "", "",item.id, item.item_description, item.qty, item.cost, item.taxable, item.created_at]
            end
            counter +=1
          end
        end
      end
    end
  end
 
end
