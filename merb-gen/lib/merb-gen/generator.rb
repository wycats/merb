module Merb

  class Generator < Templater::Generator
    def source_root
      File.join(File.dirname(__FILE__), '..', '..', 'templates')
    end
  end
  
  module ApplicationGenerators
    
    extend Templater::Manifold
    
    desc <<-DESC
      Generate a merb application
    DESC
    
    class ApplicationGenerator < Merb::Generator
      def source_root
        File.join(super, 'application')
      end
    end    
  end
  
  module ComponentGenerators
    
    extend Templater::Manifold
    
    desc <<-DESC
      Generate code to speed up the development of your merb application
    DESC
    
    class ComponentGenerator < Merb::Generator
      def source_root
        File.join(super, 'component')
      end
    end
  end  
  
end