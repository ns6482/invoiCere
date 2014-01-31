module ApplicationHelper
 def setup_user(user)           
    user.build_company
    user
  end
  
  def render_th(heading, detail)
    content_tag :tr do
      content_tag :th do
        concat heading
        concat content_tag :td, detail
      end
    end
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

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end


end
