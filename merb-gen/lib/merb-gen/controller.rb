module Merb::ComponentGenerators
  
  class ControllerGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a controller generator
    DESC
    
    option :testing_framework, :default => :spec, :desc => 'Specify which testing framework to use (spec, test_unit)'
    
    first_argument :name, :required => true
    
    template :controller do
      source('controller.rbt')
      destination("app/controllers/#{file_name}.rb")
    end
    
    #template :helpers do
    #  source('helpers.rbt')
    #  destination("app/helpers/#{file_name}_helpers.rb")
    #end
    
    #template :spec, :testing_framework => :spec do
    #  source('spec.rbt')
    #  destination('spec/models/' + file_name + '_spec.rb')
    #end
    #
    #template :test_unit, :testing_framework => :test_unit do
    #  source('test_unit.rbt')
    #  destination('test/models/' + file_name + '_test.rb')
    #end
    
    def controller_modules
      %w(Monkey Blah Gurr)
    end
    
    def controller_class_name
      self.name.camel_case
    end
    
    def test_class_name
      self.class_name + "Test"
    end
    
    def file_name
      self.name.snake_case
    end
    
    def attributes?
      self.attributes && !self.attributes.empty?
    end
    
    def attributes_for_accessor
      self.attributes.map{|a| ":#{a}" }.compact.uniq.join(", ")
    end
    
    def source_root
      File.join(super, 'controller')
    end
    
  end
  
  add :controller, ControllerGenerator
  
end