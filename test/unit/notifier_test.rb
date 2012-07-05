require 'test_helper'
require "cancan"

class NotifierTest < ActionMailer::TestCase
  def setup
    @company = FactoryGirl.create(:company)
    @client = FactoryGirl.create(:client, :company_id => @company.id)
    @invoice = FactoryGirl.create(:invoice, :client_id=>@client.id)
    @setting = FactoryGirl.create(:setting,:id=>1, :company_id => @company.id)
    @delivery = FactoryGirl.build(:delivery, :invoice_id => @invoice.id)
    @schedule = schedules(:one)
  end

  def test_email_delivery

    @delivery.contacts << FactoryGirl.build(:contact)
    @delivery.contacts << FactoryGirl.build(:contact)
    @delivery.save!
    
    assert_emails 0
    # Send the email, then test that it got queued
    email = Notifier.invoice(@delivery).deliver # sends the email
    assert_emails 1
    
    #recipients = @delivery.contacts.collect("") { |acc, contact| acc << "#{contact.email}"}
    recipients = Array.new

    for contact in @delivery.contacts
      recipients << contact.email.to_s
    end

    assert_equal recipients, email.to

    assert_equal  @delivery.invoice.title, email.subject       
    assert_match /#{@delivery.message}/, email.body.to_s
    assert_match /#{@delivery.invoice.client.company_name}/, email.body.to_s

  end

   def test_email_delivery_pdf

    @delivery.contacts << FactoryGirl.build(:contact)
    @delivery.contacts << FactoryGirl.build(:contact)
    @delivery.save!

    assert_emails 0
    # Send the email, then test that it got queued
    email = Notifier.invoice(@delivery).deliver # sends the email
    assert_emails 1

    #recipients = @delivery.contacts.collect("") { |acc, contact| acc << "#{contact.email}"}
    recipients = Array.new

    for contact in @delivery.contacts
      recipients << contact.email.to_s
    end

    assert_equal recipients, email.to

    assert_equal  @delivery.invoice.title, email.subject
    assert_match /#{@delivery.message}/, email.body.to_s
    assert_match /#{@delivery.invoice.client.company_name}/, email.body.to_s

  end

  def test_email_schedule

    @schedule.contacts << FactoryGirl.build(:contact)
    @schedule.contacts << FactoryGirl.build(:contact)
    @schedule.save!

    #@invoice = FactoryGirl.create(:invoice)

    assert_emails 0
    # Send the email, then test that it got queued
    email = Notifier.schedule(@invoice, @schedule).deliver # sends the email
    assert_emails 1

    #recipients = @delivery.contacts.collect("") { |acc, contact| acc << "#{contact.email}"}
    recipients = Array.new

    for contact in @schedule.contacts
      recipients << contact.email.to_s
    end

    assert_equal recipients, email.to

    assert_equal  @invoice.title, email.subject
    assert_match /#{@schedule.message}/, email.body.to_s
    assert_match /#{@invoice.client.company_name}/, email.body.to_s

  end


end
