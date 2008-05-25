module Merb

  class Generator < Templater::Generator
    def source_root
      File.join(File.dirname(__FILE__), '..', 'templates')
    end
  end
  
  module ApplicationGenerators
    extend Templater::Manifold
    
    class ApplicationGenerator < Merb::Generator
      def source_root
        File.join(super, 'application')
      end
    end    
  end
  
  module ComponentGenerators
    extend Templater::Manifold
    
    class ComponentGenerator < Merb::Generator
      def source_root
        File.join(super, 'component')
      end
    end
  end  
  
end