require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
   def test_should_be_valid
    assert Factory.build(:company)
  end
end
