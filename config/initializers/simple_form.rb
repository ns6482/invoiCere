# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  
  
  config.label_class = 'control-label'
  config.button_class = 'btn'
  config.form_class = 'form-horizontal'
  config.default_wrapper = :bootstrap


  config.wrappers :bootstrap, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end
   
end
