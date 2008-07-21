module Merb::Generators
  
  class HelperGenerator < ComponentGenerator

    def self.source_root
      File.join(super, 'helper')
    end
    
    desc <<-DESC
      Generates a new helper.
    DESC
    
    option :testing_framework, :desc => 'Testing framework to use (one of: spec, test_unit)'
    
    first_argument :name, :required => true, :desc => "helper name"
    
    template :helper do
      source('app/helpers/%file_name%_helper.rb')
      destination("app/helpers/#{file_name}_helper.rb")
    end
    
    template :helper_spec, :testing_framework => :rspec do
      source('spec/helpers/%file_name%_helper_spec.rb')
      destination("spec/helpers/#{file_name}_helper_spec.rb")
    end
    
    def helper_modules
      chunks[0..-2]
    end
    
    def helper_class_name
      chunks.last
    end
    
    def full_class_name
      chunks.join('::')
    end
    
    def file_name
      helper_class_name.snake_case
    end
    
    protected
    
    def chunks
      name.gsub('/', '::').split('::').map { |c| c.camel_case }
    end
    
  end
  
  add :helper, HelperGenerator
  
end
