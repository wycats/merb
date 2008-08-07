module Merb::Generators
  
  class ControllerGenerator < NamespacedGenerator

    def self.source_root
      File.join(super, 'component', 'controller')
    end
    
    desc <<-DESC
      Generates a new controller.
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: spec, test_unit)'
    
    first_argument :name, :required => true, :desc => "controller name"
    
    invoke :helper
    
    template :controller do
      source('app/controllers/%file_name%.rb')
      destination("app/controllers", base_path, "#{file_name}.rb")
    end
    
    template :index do
      source('app/views/%file_name%/index.html.erb')
      destination("app/views", base_path, "#{file_name}/index.html.erb")
    end
    
    template :controller_spec, :testing_framework => :rspec do
      source('spec/controllers/%file_name%_spec.rb')
      destination("spec/controllers", base_path, "#{file_name}_spec.rb")
    end
    
    template :controller_test_unit, :testing_framework => :test_unit do
      source('test/controllers/%file_name%_test.rb')
      destination("test/controllers", base_path, "#{file_name}_test.rb")
    end
    
  end
  
  add :controller, ControllerGenerator
  
end
