module Merb::Generators
  
  class ResourceGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a resource generator
    DESC
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :array
    
    invoke Merb::Generators::ModelGenerator
    invoke Merb::Generators::ResourceControllerGenerator do
      [controller_name, *attributes]
    end
    
    def controller_name
      name.pluralize
    end
    
  end
  
  add :resource, ResourceGenerator
  
end