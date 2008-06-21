module Merb::Generators
  
  class ResourceGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a resource generator
    DESC
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash
    
    invoke Merb::Generators::ModelGenerator do
      [model_name, *attributes]
    end
    invoke Merb::Generators::ResourceControllerGenerator do
      [controller_name]
    end
    
    def controller_name
      name.pluralize
    end
    
    def model_name
      name.singularize
    end
    
  end
  
  add :resource, ResourceGenerator
  
end