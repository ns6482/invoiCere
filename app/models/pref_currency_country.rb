class PrefCurrencyCountry < ActiveHash::Base
  self.data = [
    {:id => 1, :name => "US"},
    {:id => 2, :name => "Canada"}
  ]
end