module Merb

  module Generators
    
    extend Templater::Manifold
    
    desc <<-DESC
      Generate components for your application or entirely new applications.
    DESC
    
    class Generator < Templater::Generator
    
      # Inside a template, wraps a block of code properly in modules, keeping the indentation correct
      # TODO: spec me
      def with_modules(modules, options={}, &block)
        text = capture(&block)
        modules.each_with_index do |mod, i|
          concat(("  " * i) + "module #{mod}\n", block.binding)
        end
        text = text.to_a.map{ |line| ("  " * modules.size) + line }.join
        concat(text, block.binding)
        modules.reverse.each_with_index do |mod, i|
          concat(("  " * (modules.size - i - 1)) + "end # #{mod}\n", block.binding)
        end
      end
    
      def source_root
        File.join(File.dirname(__FILE__), '..', '..', 'templates')
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
  
end