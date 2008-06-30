module Merb::Generators
  
  class ResourceGenerator < ComponentGenerator
    
    desc <<-DESC
      This is a resource generator
    DESC
    
    first_argument :name, :required => true
    second_argument :attributes, :as => :hash
    
    invoke :model do |generator|
      generator.new(destination_root, options, model_name, attributes)
    end
    
    invoke :resource_controller do |generator|
      generator.new(destination_root, options, controller_name, attributes)
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