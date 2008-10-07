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

    def after_generation
      STDOUT.puts <<-EOS
\n\nDon't forget to add request/controller and model tests first.

Generated templates use form helpers from merb-helpers.
You may need to add dependency 'merb-helpers' in your init.rb file:

dependency 'merb-helpers'
EOS
    end
  end
  
  add :resource, ResourceGenerator
end
