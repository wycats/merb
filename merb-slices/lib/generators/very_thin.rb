module Merb::Generators
  
  class VeryThinSliceGenerator < NamedGenerator

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'very_thin')
    end
    
    glob!
    
    first_argument :name, :required => true
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :very_thin_slice, VeryThinSliceGenerator
  
end