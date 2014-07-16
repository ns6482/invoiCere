## app/inputs/date_time_picker_input.rb
class DateTimePickerInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div, class: 'input-append date input-group date form_datetime') do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat span_table
    end
  end
  
  

  def input_html_options
    {class: 'form-control', data: {'format' => "YYYY-MM-DD"}, :type => "text", readonly: true}
  end


  def span_table
    template.content_tag(:span, class: 'input-group-addon add-on') do
      template.concat icon_table
    end
  end
  


  def icon_table
    "<i class='glyphicon glyphicon-th'></i>".html_safe
  end

end