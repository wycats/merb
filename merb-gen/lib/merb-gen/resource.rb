module Merb::Generators
  
  class ResourceGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a resource generator
    DESC
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :array
    
    invoke Merb::Generators::ModelGenerator
    
    def class_name
      self.name.camel_case
    end
    
    def test_class_name
      self.class_name + "Test"
    end
    
    def file_name
      self.name.snake_case
    end
    
    def source_root
      File.join(super, 'resource')
    end
    
  end
  
  add :resource, ResourceGenerator
  
end