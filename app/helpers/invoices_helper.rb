module InvoicesHelper
  
 
 def link_to_btn(name, path, options = {})
   options[:class] ? options[:class] += ' btn btn-default' : options[:class] = 'btn btn-default'
   link_to(name, path, options)
 end

end