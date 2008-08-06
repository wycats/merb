module Merb::Generators
  
  class ThinSliceGenerator < NamedGenerator

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'thin')
    end
    
    glob!
    
    first_argument :name, :required => true
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :thin_slice, ThinSliceGenerator
  
end