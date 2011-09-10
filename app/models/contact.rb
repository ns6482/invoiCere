class Contact < ActiveRecord::Base
  attr_accessible :title, :first_name, :last_name, :job_title, :email, :phone, :mobile, :fax, :delivery_ids
  attr_accessor :company_id
  belongs_to :client

  #has_many :sends
  has_many :deliveries, :through => :sends

  accepts_nested_attributes_for :deliveries


  validates_presence_of :title, :first_name, :last_name,:email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def fullname
    first_name + " " + last_name
  end

  def name
    first_name + " " + last_name
  end

  def company_id
    self.client.company_id
  end

  def invited?
    User.exists?(:email => self.email, :company_id => self.client.company_id, :client_id => self.client_id)
  end

end
