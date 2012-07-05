require 'test_helper'

class ContactTest < ActiveSupport::TestCase

   def test_failing_create
    contact = Contact.new
    assert !contact.save
    assert_equal 5, contact.errors.size

    assert_equal contact.errors[:title].count, 1
    assert_equal contact.errors[:first_name].count, 1
    assert_equal contact.errors[:last_name].count, 1
    assert_equal contact.errors[:email].count, 2

  end

  def test_should_not_save_with_bad_email
    contact = FactoryGirl.build(:contact, :email=>"bademail")
    assert !contact.save, "Save contact wth bad email"

    contact = FactoryGirl.build(:contact, :email=>"bademail@")
    assert !contact.save, "Save contact with bad email"

    contact = FactoryGirl.build(:contact, :email=>".com@,sds.com")
    assert !contact.save, "Save contact with bad email"

    contact = FactoryGirl.build(:contact, :email=>"goodemail@test.com")
    assert contact.save, "Save contact with good email"
  end

  def test_full_name
    contact = FactoryGirl.build(:contact, :first_name =>"foo", :last_name => "foo1")
    assert contact.fullname, "foo foo1"
  end
  
end
