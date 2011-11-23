class Client < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10

  belongs_to :company
  has_many :contacts, :dependent => :destroy
  has_many :invoices
  has_many :users

  validates_presence_of :company_name, :address1, :email#,:company_id
  validates_uniqueness_of :company_name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  attr_accessible :company_name, :address1, :address2, :zip, :city, :country, :phone, :fax, :email, :company_id
  attr_accessor :display_address, :display_fax, :display_phone

  attr_searchable :company_name, :address1, :address2, :zip, :city, :country, :phone, :email

  scope :due, where("invoices.due_date <= '#{Date.today}' and invoices.state = 'open'")

  scope :with_aggregates, 
  :select => "clients.*,MIN(invoices.due_date) AS min_due_date, SUM(invoices.total_cost_inc_tax_delivery) AS total_due, COUNT(DISTINCT(invoices.id)) AS count_invoices, SUM(payments.amount) as total_paid ", 
  :joins => ["LEFT JOIN 'invoices' ON invoices.client_id = clients.id LEFT JOIN payments ON invoices.id = payments.invoice_id"],
  :group => "clients.id"

  scope :outstanding, due.with_aggregates#.having("total_due >= 0") 
  
    #:select => "clients.*, SUM(invoices.total_cost_inc_tax_delivery) AS total_due, COUNT(DISTINCT(invoices.id)) AS count_invoices, SUM(payments.amount) as total_paid ", 
    #:joins => ["JOIN 'invoices' ON invoices.client_id = clients.id LEFT JOIN payments ON invoices.id = payments.invoice_id"],
    #:conditions => "invoices.due_date <= '#{Date.today}' and invoices.state = 'open'",
    #:group => "clients.id"
    
  def name
    company_name
  end

  def display_address
    str = ""
    str += address1.strip
    str += ", " + address2.strip unless address2.blank?
    str += ", " + city.strip unless city.blank?
    str += ", " + country.strip unless country.blank?
    str += ", " + zip.strip unless zip.blank?
  end

  def display_phone
    "Phone: (" + phone.strip + ")" unless phone.blank?
  end

  def display_fax
    "Fax: (" + fax.strip + ")" unless fax.blank?
  end

  def invited?
    User.exists?(:email => self.email, :company_id => self.company_id, :client_id => self.id)
  end

  #   def editable_by?(some_user)
  #     some_user.admin? || some_user == user
  #   end
end
