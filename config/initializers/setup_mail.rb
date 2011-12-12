ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",  
  :user_name => "nehal.soni",
  :password => "Shawshank1",
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}

ActionMailer::Base.default_url_options[:host] = "lvh.me:3000"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?


