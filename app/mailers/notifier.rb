require "open-uri"
require 'money'

class Notifier < ActionMailer::Base
  #include Resque::Mailer
  layout 'email'
  helper :application

  
  default :from => 'no-reply@example.com',
    :return_path => 'system@example.com'
  

  def invoice_pdf(delivery, invoice_link = nil, direct_link = nil, subject = nil)
    @delivery = delivery
    @invoice  = @delivery.invoice
    @client = @invoice.client
    @msg = RedCloth.new(Liquid::Template.parse(@delivery.message.gsub("{{","{{d.").gsub("{{d.invoice_link}}", "{{invoice_link}}").gsub("{{d.direct_link}}", "{{direct_link}}")).render('d' => @delivery,'invoice_link' => invoice_link, 'direct_link' => direct_link ))
    
    logo_url = @client.company.setting.logo.url
    pdf_file =  InvoiceReport.new(@delivery.invoice, logo_url).to_pdf
 
    attachments["invoice.pdf"] = {:mime_type => 'application/pdf', :content => pdf_file }


    mail(
      :subject  =>   @delivery.invoice.title,
      :to =>  @delivery.recipients,
      :from   =>    @company,
      :body   =>  @delivery.message,
      #:attachment => {:content_type => "application/octet-stream", :filename => "Invoice details - " + @invoice.title + ".pdf", :body => pdf_file}
    ) do |format|
       format.html { render :layout => 'email' }

    end
  end

  def invoice(delivery, invoice_link = nil, direct_link = nil, subject = nil)
    @delivery = delivery
    @invoice  = @delivery.invoice
    @client = @invoice.client
      
    @msg = RedCloth.new(Liquid::Template.parse(@delivery.message.gsub("{{","{{d.").gsub("{{d.invoice_link}}", "{{invoice_link}}").gsub("{{d.direct_link}}", "{{direct_link}}")).render('d' => @delivery,'invoice_link' => invoice_link, 'direct_link' => direct_link ))
    
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
