class Devmailer < Devise::Mailer 
  layout 'admin_email' 
  helper :application # gives access to all helpers defined within `application_helper`.
  
   default :from => 'no-reply@example.com',
    :return_path => 'system@example.com'
end