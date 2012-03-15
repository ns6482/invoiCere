require 'test_helper'

class PreferencesTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Preferences.new.valid?
  end
end
