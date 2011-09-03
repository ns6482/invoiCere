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

  def name
    company_name
  end

  def display_address
    str = ""
    str += address1.strip
    str += ", " + address2.strip unless address2.nil?
    str += ", " + city.strip unless city.nil?
    str += ", " + country.strip unless country.nil?
    str += ", " + zip.strip unless zip.nil?
  end

  def display_phone
    "Phone: (" + phone.strip + ")" unless phone.nil?
  end

  def display_fax
    "Fax: (" + fax.strip + ")" unless fax.nil?
  end

  def invited?
    User.exists?(:email => self.email, :company_id => self.company_id, :client_id => self.id)
  end

  #   def editable_by?(some_user)
  #     some_user.admin? || some_user == user
  #   end
end
