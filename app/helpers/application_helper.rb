module ApplicationHelper
 def setup_user(user)           
    user.build_company
    user
  end
  
   def csymb(sym, val, display_at_end = false)
    return unless val
    
    if !display_at_end 
      result = sym.to_currency.symbol + val.to_s
    else
      result = val.to_s + sym.to_currency.symbol
    end
    
    content_tag(:span, result, :class => "money")
  end


end
