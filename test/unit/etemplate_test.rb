require 'test_helper'

class EtemplateTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Etemplate.new.valid?
  end
end
