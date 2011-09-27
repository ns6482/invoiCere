require 'test_helper'

class ScheduleSendTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ScheduleSend.new.valid?
  end
end
