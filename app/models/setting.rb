
class Setting < ActiveRecord::Base
  belongs_to :company
  attr_protected :company_id#, :setting_id
  attr_accessor :contact

  #has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }#,
  #:url => "/system/:attachment/:id/:style/:basename.:extension",
  #:path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
  
  
  has_attached_file :logo,
       :styles => {
        :medium => "300x300>", 
        :thumb => "100x100>" 
       },
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yaml",
     :path => "/:style/:id/:filename"

  validates_numericality_of :vat, :allow_blank => true
  #validates_attachment_presence :logo
  validates_attachment_size :logo, :less_than => 1.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of     :email, :with  => EmailRegex, :allow_blank => true
  
  def test
    "test"
  end
  
  def contact

    company_contact = ""
    
    if self.telephone
      if self.telephone.length > 0
        company_contact += "Tel: #{self.telephone}   "
      end
    end

    if self.fax
      if self.fax.length >0
        company_contact += "Fax: #{self.fax}   "
      end
    end

    if self.email
      if self.email.length >0
        company_contact += "Email: #{self.email}"
      end
    end

    company_contact
  end

  
end
