module Merb::Generators
  
  class FullSliceGenerator < NamedGenerator

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'full')
    end
    
    def self.common_template(name, source)
      template name do 
        @source = File.join(File.dirname(__FILE__), 'templates', 'common', source)
        @destination = source
      end
    end
    
    glob!
    
    common_template :javascript,  File.join('public/javascripts/master.js')
    common_template :stylesheet,  File.join('public/stylesheets/master.css')
    
    common_template :license,     File.join('LICENSE')
    
    common_template :merbtasks,   File.join('lib', '%base_name%', 'merbtasks.rb')
    common_template :slicetasks,  File.join('lib', '%base_name%', 'slicetasks.rb')
    common_template :spectasks,   File.join('lib', '%base_name%', 'spectasks.rb')
    
    first_argument :name, :required => true
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :full_slice, FullSliceGenerator
  
end