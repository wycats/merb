module Merb::Generators
  
  class VeryThinSliceGenerator < NamedGenerator

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', 'very_thin')
    end
    
    def self.common_template(name, source)
      template name do 
        @source = File.join(File.dirname(__FILE__), 'templates', 'common', source)
        @destination = source
      end
    end
    
    glob!
    
    common_template :application, File.join('application.rb')
    
    common_template :rakefile,    File.join('Rakefile')
    common_template :license,     File.join('LICENSE')
    common_template :todo,        File.join('TODO')
    
    common_template :merbtasks,   File.join('lib', '%base_name%', 'merbtasks.rb')
    common_template :slicetasks,  File.join('lib', '%base_name%', 'slicetasks.rb')
    
    first_argument :name, :required => true
    
    def destination_root
      File.join(@destination_root, base_name)
    end
    
  end
  
  add_private :very_thin_slice, VeryThinSliceGenerator
  
end