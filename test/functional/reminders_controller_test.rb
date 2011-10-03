require 'test_helper'

class RemindersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

 def setup
    @user = users(:user)#Factory.create(:user)
    @request.host = @user.company.name + ".lvh.me"
    @invoice = invoices(:one)
    sign_in @user

  end

  def teardown
    sign_out @user
  end
    
  def test_show
    get :show, :invoice_id => @invoice
    assert_template 'show'
  end

  def test_show_message_no_reminder

    @reminder = @invoice.reminder
    @reminder.enabled = false
    @reminder.save!

    get :show, :invoice_id => @invoice
    assert_template 'show'
    assert_select 'p', "No reminder set"

  end

  def test_show_message_reminder_not_yet_sent

    @reminder = @invoice.reminder
    @reminder.enabled = true
    @reminder.days_before = 3
    @reminder.frequency = "weekly"
    @reminder.save!
    
    get :show, :invoice_id => @invoice
    assert_template 'show'
    assert_select 'p', "Reminder set weekly, starting 3 day(s) before due date. A reminder will be sent on 10/02/2011. The reminder was last sent on 10/02/2011"

  end

  def test_show_message_reminder_already_sent

    @reminder = @invoice.reminder
    @reminder.last_send = "2011-02-09"
    @reminder.enabled = true
    @reminder.days_before = 3
    @reminder.frequency = "weekly"
    @reminder.save!

    get :show, :invoice_id => @invoice
    assert_template 'show'
    assert_select 'p', "Reminder set weekly, starting 3 day(s) before due date. A reminder will be sent on 10/02/2011. The reminder was last sent on 09/02/2011"

  end

  def test_edit    
    get :edit, :invoice_id => @invoice.id
    assert_template 'edit'
  end

  def test_update_invalid
    Reminder.any_instance.stubs(:valid?).returns(false)
    put :update, :invoice_id => @invoice.id
    assert_template 'edit'
  end

  def test_update_valid
    Reminder.any_instance.stubs(:valid?).returns(true)
    put :update, :invoice_id => @invoice.id
    assert_redirected_to invoice_url(assigns(:invoice))
  end

end
