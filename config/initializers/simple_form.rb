# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  
 config.wrappers :tag => :div, :class => :input,
                  :error_class => :field_with_errors do |b|
    # Extensions
    b.use :html5
    b.optional :pattern
    b.use :maxlength
    b.use :placeholder
    b.use :readonly

    # Inputs
    b.use :label_input
    b.use :hint,  :wrap_with => { :tag => :span, :class => :hint }
    b.use :error, :wrap_with => { :tag => :span, :class => :error }
  end
  
  config.wrappers :inline_checkbox, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :label_input, :wrap_with => { :class => 'checkbox inline' }
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end
  
end
