class Devmailer < Devise::Mailer 
  layout 'admin_email' 
  helper :application # gives access to all helpers defined within `application_helper`.
  
   default :from => 'no-reply@example.com',
    :return_path => 'system@example.com'
    
    
  def invitation_instructions(record, opts={}) 
    super
  end
  
  def confirmation_instructions(record, opts={}) 
    super
  end
  
  def reset_password_instructions(record, opts={}) 
    super
  end
  
  def unlock_instructions(record, opts={}) 
    super  
  end
    
end