module Merb::Generators
  
  class ResourceGenerator < Generator
    
    desc <<-DESC
      Generates a new resource.
    DESC
    
    first_argument :name, :required => true, :desc => "resource name (singular)"
    second_argument :attributes, :as => :hash, :default => {}, :desc => "space separated resource model properties in form of name:type. Example: state:string"
    
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
      name
    end
    
  end
  
  add :resource, ResourceGenerator
  
end
