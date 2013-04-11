class User < ActiveRecord::Base
  belongs_to :company
  #belongs_to :clients
  has_and_belongs_to_many :roles, :autosave => true
  #has_many :payments  

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable,  :authentication_keys =>[:email, :company_id]#,:encryptable,#,:invitable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  accepts_nested_attributes_for :company#, :roles
  attr_protected :company_id,  :email#, :client_id


  validates_associated :company
  validates_confirmation_of :password
  validates_length_of :password, :within => 6..20, :allow_blank => true

  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of     :email, :with  => EmailRegex, :allow_blank => false
  

  validates :email, :presence => true, :uniqueness => {:scope => [:company_id, :email]}

  
  validate :has_roles?


  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  

  def self.find_for_authentication(conditions={})
    conditions[:companies] = { :name => conditions.delete(:company_id) }
    find(:first, :conditions => conditions, :include => :company)    
  end

  def has_roles?
   errors.add_to_base "User must have at least one role." if self.role_ids.blank?
  end
  
    
  def update_with_password(params={})
    params.delete(:email)
    super(params)
  end

  
  def update_without_password(params={})
    params.delete(:email)
    super(params)
  end

  
end
