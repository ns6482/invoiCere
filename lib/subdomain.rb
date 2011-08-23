class Subdomain
 #before_filter :set_mailer_url_options

  def self.matches?(request)
    request.subdomain.present? && request.subdomain != "lvh"
  end
  
  def set_mailer_url_options
    ActionMailer::Base.default_url_options[:host] = with_subdomain(request.subdomain)
  end

end
