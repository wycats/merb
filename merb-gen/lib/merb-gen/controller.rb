module Merb::Generators
  
  class ControllerGenerator < ComponentGenerator

    def self.source_root
      File.join(super, 'controller')
    end
    
    desc <<-DESC
      Generates a new controller.
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: spec, test_unit)'
    
    first_argument :name, :required => true, :desc => "controller name"
    
    invoke :helper
    
    template :controller do
      source('app/controllers/%file_name%.rb')
      destination("app/controllers/#{file_name}.rb")
    end
    
    template :index do
      source('app/views/%file_name%/index.html.erb')
      destination("app/views/#{file_name}/index.html.erb")
    end
    
    template :controller_spec, :testing_framework => :rspec do
      source('spec/controllers/%file_name%_spec.rb')
      destination("spec/controllers/#{file_name}_spec.rb")
    end
    
    template :controller_test_unit, :testing_framework => :test_unit do
      source('test/controllers/%file_name%_test.rb')
      destination("test/controllers/#{file_name}_test.rb")
    end
    
    def controller_modules
      chunks[0..-2]
    end
    
    def controller_class_name
      chunks.last
    end
    
    def full_class_name
      chunks.join('::')
    end
    
    def test_class_name
      controller_class_name + "Test"
    end
    
    def file_name
      controller_class_name.snake_case
    end
    
    protected
    
    def chunks
      name.gsub('/', '::').split('::').map { |c| c.camel_case }
    end
    
  end
  
  add :controller, ControllerGenerator
  
end
