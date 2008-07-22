module Merb::Generators
  
  class ThinSliceGenerator < ApplicationGenerator

    def self.source_root
      File.join(super, 'slice', 'thin')
    end
    
    glob!
    
    first_argument :name, :required => true
    
    def module_name
      self.name.camel_case
    end
    
    def base_name
      self.name.snake_case
    end
    
    alias_method :underscored_name, :base_name
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :thin_slice, ThinSliceGenerator
  
end