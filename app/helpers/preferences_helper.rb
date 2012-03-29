module PreferencesHelper
  
  def country_options_for_select(selected = nil, priority_countries = nil)
  country_options = "".html_safe

  if priority_countries
    priority_countries = [*priority_countries].map {|x| [x,ISO3166::Country::NameIndex[x]] }
    country_options += options_for_select(priority_countries, selected)
    country_options += "<option value=\"\" disabled=\"disabled\">-------------</option>\n".html_safe
  end

  return country_options + options_for_select(ISO3166::Country::Names, selected)
end
end
