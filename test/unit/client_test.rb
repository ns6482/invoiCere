require 'test_helper'
 

class ClientTest < ActiveSupport::TestCase

  def test_failing_create
    client = Client.new
    assert !client.save
    assert_equal 4, client.errors.size
    
    assert_equal client.errors[:company_name].count, 1
    assert_equal client.errors[:address1].count, 1
    assert_equal client.errors[:email].count, 2

  end

  def test_name
    @client = FactoryGirl.build(:client)
    assert_equal @client.name, @client.company_name# + ' - ' + @client.address1
  end

  def test_display_address
    @client = FactoryGirl.create(:client, :address1=> "a", :zip=>"   1234     ")
    assert_equal @client.display_address, "a, test, Nuneaton, United Kingdom, 1234"
  end

  def test_display_contacts
    @client = FactoryGirl.create(:client, :email=>"nehal.soni@gmail.com", :phone=> "  2323 ", :fax => "  12")
    assert_equal @client.display_phone, "Phone: (2323)"
    assert_equal @client.display_fax, "Fax: (12)"

  end
  
  def test_should_not_save_with_bad_email
    client = FactoryGirl.build(:client, :email=>"bademail")
    assert !client.save, "Save client wth bad email"

    client = FactoryGirl.build(:client, :email=>"bademail@")
    assert !client.save, "Save client with bad email"
    
    client = FactoryGirl.build(:client, :email=>".com@,sds.com")
    assert !client.save, "Save client with bad email"

    client = FactoryGirl.build(:client, :email=>"goodemail@test.com")
    assert client.save, "Save client with good email"
  end
  
end
