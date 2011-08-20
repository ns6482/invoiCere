class Setting < ActiveRecord::Base
  belongs_to :company
  attr_protected :company_id, :setting_id

  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }#,
  #:url => "/system/:attachment/:id/:style/:basename.:extension",
  #:path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"

  validates_numericality_of :vat
  #validates_attachment_presence :logo
  validates_attachment_size :logo, :less_than => 1.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of     :email, :with  => EmailRegex, :allow_blank => true
end
