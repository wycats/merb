module Merb::Generators
  
  class ControllerGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a controller generator
    DESC
    
    option :testing_framework, :desc => 'Specify which testing framework to use (spec, test_unit)'
    
    first_argument :name, :required => true
    
    template :controller do
      source('controller.rbt')
      destination("app/controllers/#{file_name}.rb")
    end
    
    template :helper do
      source('helper.rbt')
      destination("app/helpers/#{file_name}_helper.rb")
    end
    
    template :index do
      source('index.html.erbt')
      destination("app/views/#{file_name}/index.html.erb")
    end
    
    template :helper_spec, :testing_framework => :rspec do
      source('helper_spec.rbt')
      destination("spec/helpers/#{file_name}_helper_spec.rb")
    end
    
    template :controller_spec, :testing_framework => :rspec do
      source('controller_spec.rbt')
      destination("spec/controllers/#{file_name}_spec.rb")
    end
    
    template :controller_test_unit, :testing_framework => :test_unit do
      source('controller_test_unit.rbt')
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
    
    def source_root
      File.join(super, 'controller')
    end
    
    protected
    
    def chunks
      name.gsub('/', '::').split('::').map { |c| c.camel_case }
    end
    
  end
  
  add :controller, ControllerGenerator
  
end