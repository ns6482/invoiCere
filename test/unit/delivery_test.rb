require 'test_helper'

class DeliveryTest < ActiveSupport::TestCase  
  
  def test_should_be_invalid
    assert !Delivery.new.valid?
    @delivery = FactoryGirl.build(:delivery, :client_email=>false)
    assert !@delivery.valid?

  end


  def test_no_client_no_contacts_invalid

  end

  def test_should_be_invalid_no_contacts
    @delivery = FactoryGirl.build(:delivery)    
    assert !@delivery.valid?
  end

  def test_should_be_valid_with_contacts
    @delivery = FactoryGirl.build(:delivery)
    @delivery.contacts << FactoryGirl.build(:contact)
    assert @delivery.valid?
  end

  def test_recipient_names
    @delivery = FactoryGirl.build(:delivery, :client_email=>true)
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "A", :last_name=>"1")
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "B", :last_name=>"2")
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "C", :last_name=>"3")
    assert_equal  "A 1, B 2, C 3", @delivery.recipient_names
  end

  def test_recipients
    @delivery = FactoryGirl.build(:delivery, :client_email=>true)
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "A", :last_name=>"1", :email => "foo@test.com")
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "B", :last_name=>"2", :email => "foo1@test.com")
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "C", :last_name=>"3", :email => "foo2@test.com")


    assert_equal "\"" + @delivery.invoice.client.company_name + "\" <" + @delivery.invoice.client.email + ">",  @delivery.recipients[0]
    assert_equal "\"A 1\" <foo@test.com>",  @delivery.recipients[1]
    assert_equal "\"B 2\" <foo1@test.com>",  @delivery.recipients[2]
    assert_equal "\"C 3\" <foo2@test.com>",  @delivery.recipients[3]
  end


  def test_message_short
    @delivery = FactoryGirl.build(:delivery, :message =>'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb')
    @delivery.contacts << FactoryGirl.build(:contact, :first_name => "A", :last_name=>"1")    
    assert_equal 50, @delivery.message_short.size
  end

end
