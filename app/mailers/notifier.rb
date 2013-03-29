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

  def invoice(delivery)
    @delivery = delivery
    @invoice  = @delivery.invoice
    @client = @invoice.client
    #@company = @client.company
  
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
