require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @company = Factory.create(:company)
    @company1 = Factory.create(:company)
  end

  def teardown
  end
  
  def test_create_multiple_users_invalid_same_email_company
    @user = Factory.build(:user, :email=> 'foo@foo.com', :company_id => @company)
    @user1 = Factory.build(:user, :email=> 'foo@foo.com',  :company_id => @company)
    assert @user.save!
    assert !@user1.save
    assert @user1.errors[:email].present?
  end

  def test_create_multiple_users_valid_same_email_different_company
    @user = Factory.build(:user,  :email=> 'foo@foo.com', :company_id => @company.id)
    @user1 = Factory.build(:user,  :email=> 'foo@foo.com',  :company_id => @company1.id)
    assert_not_equal @company.id, @company1.id
    assert_equal @user.email, @user1.email
    assert @user1.save!
    assert @user.save!
  end

  def test_create_multiple_users_valid_same_company_different_email
    @user = Factory.build(:user, :email=> 'foo@foo.com', :company_id => @company)
    @user1 = Factory.build(:user, :email=> 'foo1@foo.com',  :company_id => @company)
    assert @user.save!
    assert @user1.save!
  end
  
end
