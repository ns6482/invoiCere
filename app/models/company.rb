class Company < ActiveRecord::Base
  extend FriendlyId

  has_many :users, :dependent => :destroy
  #has_many :accounts, :dependent => :destroy
  has_many :clients, :dependent => :destroy
  has_many :invoices, :through => :clients#, :dependent => :destroy
  has_many :deliveries, :through => :clients, :source => :invoices
  has_many :schedules, :through => :clients, :source => :invoices

  has_many :schedules,  :finder_sql =>
    proc {"SELECT s.* " +
    "FROM schedules  s JOIN invoices i ON s.invoice_id = i.id " +
    "JOIN clients c ON i.client_id = c.id " +
    "WHERE c.company_id = #{id}"}

  has_one :etemplate, :dependent => :destroy
  has_one :setting, :dependent => :destroy
  
  after_create :set_setting

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name

  attr_accessible :name, :setting_attributes, :etemplate_attributes
  accepts_nested_attributes_for :users

  has_friendly_id :name

  validates_format_of :name, :with => /^\w+$/i, :message => "can only contain letters and numbers."

  accepts_nested_attributes_for :users, :setting, :etemplate

  def get_invoices_by_state
    self.invoices.group_by {|i| i.formatted_state }
  end
  
  private


  def set_setting
     s = Setting.new() 
     s.company_id = self.id
     s.save!
     
     e = Etemplate.new()
     e.company_id = self.id
     e.save!
     ##TODO put defaults here
     ##setting.save!          
  end

end
