module Merb::Generators
  
  class VeryThinSliceGenerator < ApplicationGenerator

    def self.source_root
      File.join(File.dirname(__FILE__), '..', '..', 'templates', 'very_thin')
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
  
  add_private :very_thin_slice, VeryThinSliceGenerator
  
end