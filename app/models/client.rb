class Client < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10

  belongs_to :company
  has_many :contacts, :dependent => :destroy
  has_many :invoices
  has_many :users
  has_many :schedules

  validates_presence_of :company_name, :address1#,:company_id
  validates_uniqueness_of :company_name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :unless => Proc.new {|c| c.email.blank?}

  attr_accessible :company_name, :address1, :address2, :zip, :city, :country, :phone, :fax, :email, :company_id
  attr_accessor :display_address, :display_fax, :display_phone

  attr_searchable :company_name, :address1, :address2, :zip, :city, :country, :phone, :email

  scope :due, where("invoices.due_date <= '#{Date.today}' and invoices.state = 'open'")

  scope :with_aggregates,
  :select => "clients.*,MIN(invoices.due_date) AS min_due_date, SUM(invoices.total_cost_inc_tax_delivery) AS total_due, COUNT(DISTINCT(invoices.id)) AS count_invoices, SUM(payments.amount) as total_paid ",
  :joins => ["LEFT JOIN invoices ON invoices.client_id = clients.id LEFT JOIN payments ON invoices.id = payments.invoice_id"],
  :group => "clients.id"

  scope :outstanding, due.with_aggregates#.having("total_due >= 0")

  scope :users,
  :select => "clients.*",
  :joins => ["JOIN users ON clients.id = users.client_id"]

  #:select => "clients.*, SUM(invoices.total_cost_inc_tax_delivery) AS total_due, COUNT(DISTINCT(invoices.id)) AS count_invoices, SUM(payments.amount) as total_paid ",
  #:joins => ["JOIN 'invoices' ON invoices.client_id = clients.id LEFT JOIN payments ON invoices.id = payments.invoice_id"],
  #:conditions => "invoices.due_date <= '#{Date.today}' and invoices.state = 'open'",
  #:group => "clients.id"
  def name
    company_name
  end

  def display_address
    str = (address1.blank?  ? "" : address1) 
    str += (address2.blank? ? "" : ', ' + address2)  
    str += (city.blank? ? "" : ', ' + city)
    str += (country.blank? ? "" : ', ' +  country)
    str += (zip.blank? ? "" : ', ' + zip)
  end

  def display_phone
    "Phone: (" + phone + ")" unless phone.blank?
  end

  def display_fax
    "Fax: (" + fax + ")" unless fax.blank?
  end

  def invited?
    User.exists?(:email => self.email, :company_id => self.company_id, :client_id => self.id)
  end

  def self.to_csv(all_clients)

    CSV.generate do |csv|

      csv << ["Name", "Address 1", "Address 2", "Zip", "City", "Country", "Phone", "Fax", "Email", "Created", "Contact Title", "Contact First Name", "Contact Last Name", "Contact Job Title", "Contact Email", "Contact Phone", "Contact Mobile", "Contact Fax", "Contact Created" ]
      all_clients.each do |cl|
        val = [cl.company_name, cl.address1, cl.address2, cl.zip, cl.city, cl.country, cl.phone, cl.fax, cl.email, cl.created_at]

        if cl.contacts.first
          val += [cl.contacts.first.title, cl.contacts.first.first_name, cl.contacts.first.last_name, cl.contacts.first.job_title, cl.contacts.first.email, cl.contacts.first.phone, cl.contacts.first.mobile, cl.contacts.first.fax, cl.contacts.first.created_at]
        end

        csv << val

        counter = 0

        if cl.contacts.count > 1
          cl.contacts.each do |contact|
            if counter != 0 then
              csv << ["", "", "", "", "", "", "", "", "", "", contact.first.title, contact.first_name, contact.last_name, contact.job_title, contact.email, contact.phone, contact.mobile, contact.fax, contact.created_at]
            end
            counter +=1
          end
        end

      end
    end
  end

#   def editable_by?(some_user)
#     some_user.admin? || some_user == user
#   end
end
