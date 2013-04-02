require "open-uri"
require 'money'

class Notifier < ActionMailer::Base
  layout 'email'
  helper :application

  
  default :from => 'no-reply@example.com',
    :return_path => 'system@example.com'
  

  def invoice_pdf(delivery, pdf_file)
    @delivery = delivery
    @invoice  = @delivery.invoice
    @client = @invoice.client
    
    mail(
    :subject  =>   @delivery.invoice.title,
    :recipients =>  @delivery.recipients,
    :from   =>    @company,
    :content_type =>  "text/html",
    :body   =>  @delivery.message,

    :attachment => {:content_type => "application/octet-stream", :filename => "Invoice details - " + @invoice.title + ".pdf", :body => pdf_file}
  )
  end

  def invoice(delivery, login_link = nil, direct_link = nil)
    @delivery = delivery
    @invoice  = @delivery.invoice
    @client = @invoice.client
    
    #template  = Liquid::Template.parse(@delivery.message).render('login_link' => login_link, 'direct_link' => direct_link)
    #@msg = RedCloth.new(Liquid::Template.parse(template.gsub("{{","{{d.")).render('d' => @delivery))

    
  
     @msg = RedCloth.new(Liquid::Template.parse(@delivery.message.gsub("{{","{{d.").gsub("{{d.invoice_link}}", "{{invoice_link}}").gsub("{{d.direct_link}}", "{{direct_link}}")).render('d' => @delivery,'login_link' => login_link, 'direct_link' => direct_link ))
    
  
    #TODO display subject text field for delivery
    mail(:subject => @delivery.invoice.title, :from => @company, :to =>@delivery.recipients ) do |format|
      format.html { render :layout => 'email' }
      #format.text      
    end
  end

  def schedule(invoice, schedule)
    @schedule = schedule
    @invoice  = invoice
    @client = @invoice.client
    
    mail(:subject => @invoice.title, :from => @company, :to =>@schedule.recipients, :content_type => "text/html") do |format|
     format.html { render :layout => 'email' }
   end
    
  end
end
