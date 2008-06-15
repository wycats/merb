module Merb

  class Generator < Templater::Generator
    
    # TODO: spec me
    def with_modules(modules, options={}, &block)
      text = capture(&block)
      modules.each_with_index do |mod, i|
        concat(("  " * (i * 2)) + "module #{mod}\n", block.binding)
      end
      text = text.to_a.map{ |line| ("  " * (modules.size * 2)) + line }.join
      concat(text, block.binding)
      modules.reverse.each_with_index do |mod, i|
        concat(("  " * ((modules.size - i - 1) * 2)) + "end # #{mod}\n", block.binding)
      end
    end
    
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