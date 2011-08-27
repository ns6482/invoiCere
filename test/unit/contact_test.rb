require 'test_helper'

class ContactTest < ActiveSupport::TestCase

   def test_failing_create
    contact = Contact.new
    assert !contact.save
    assert_equal 5, contact.errors.size

    assert contact.errors.on(:title)
    assert contact.errors.on(:first_name)
    assert contact.errors.on(:last_name)
    assert contact.errors.on(:email)
  end

  def test_should_not_save_with_bad_email
    contact = Factory.build(:contact, :email=>"bademail")
    assert !contact.save, "Save contact wth bad email"

    contact = Factory.build(:contact, :email=>"bademail@")
    assert !contact.save, "Save contact with bad email"

    contact = Factory.build(:contact, :email=>".com@,sds.com")
    assert !contact.save, "Save contact with bad email"

    contact = Factory.build(:contact, :email=>"goodemail@test.com")
    assert contact.save, "Save contact with good email"
  end

  def test_full_name
    contact = Factory.build(:contact, :first_name =>"foo", :last_name => "foo1")
    assert contact.fullname, "foo foo1"
  end
  
end
