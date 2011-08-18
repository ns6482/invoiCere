class Company < ActiveRecord::Base
  has_many :users, :dependent => :destroy
  #has_many :accounts, :dependent => :destroy
  #has_many :clients, :dependent => :destroy
  #has_many :invoices, :through => :clients#, :dependent => :destroy
  #has_many :deliveries, :through => :clients, :source => :invoices
  #has_many :schedules, :through => :clients, :source => :invoices

  #has_many :schedules,  :finder_sql =>
  #  'SELECT s.* ' +
  #  'FROM schedules  s JOIN invoices i ON s.invoice_id = i.id ' +
  #  'JOIN clients c ON i.client_id = c.id ' +
  #  'WHERE c.company_id = #{id}'

  #has_one :etemplate, :dependent => :destroy
  #has_one :setting, :dependent => :destroy
  
  #after_create :set_setting

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name

  attr_accessible :name#, :setting_attributes, :etemplate_attributes
  accepts_nested_attributes_for :users

  has_friendly_id :name

  validates_format_of :name, :with => /^\w+$/i, :message => "can only contain letters and numbers."

  #accepts_nested_attributes_for :setting, :users, :etemplate

  private


  #def set_setting

    # Setting.new(:company_id => self.id).save
     #Etemplate.new(:company_id => self.id).save
     ##TODO put defaults here
    ##setting.save!
    
  #end

end
