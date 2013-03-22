module InvoicesHelper
  
  def csymb(sym, val)
    content_tag(:span, sym.to_currency.symbol + val.to_s, :class => "currency_symbol")
  end

end