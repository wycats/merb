module Merb::Generators
  
  class MerbFlatGenerator < NamedGenerator
    
    def self.source_root
      File.join(super, 'application', 'merb_flat')
    end
    
    desc <<-DESC
      This generates a flat merb application: all code but config files and
      templates fits in one application. This is something in between Sinatra
      and "regular" Merb application.
    DESC
    
    first_argument :name, :required => true, :desc => "Application name"
    
    glob!
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :app_flat, MerbFlatGenerator
  
end