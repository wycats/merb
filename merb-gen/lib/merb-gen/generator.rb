module Merb
  
  ApplicationGenerators = Templater::Manifold.new
  ComponentGenerators = Templater::Manifold.new
  
  class Generator < Templater::Generator
    def source_root
      File.join(File.dirname(__FILE__), '..', 'templates')
    end
  end
  
  class ApplicationGenerator < Generator
    def source_root
      File.join(super, 'application')
    end
  end
  
  class ComponentGenerator < Generator
    def source_root
      File.join(super, 'component')
    end
  end
  
end