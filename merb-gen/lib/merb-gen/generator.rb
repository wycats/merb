module Merb

  module Generators
    
    extend Templater::Manifold
    
    desc <<-DESC
      Generate components for your application or entirely new applications.
    DESC
    
    class Generator < Templater::Generator
      
      def initialize(*args)
        super
        options[:orm] ||= Merb.orm_generator_scope
        options[:testing_framework] ||= Merb.test_framework_generator_scope
        
        options[:orm] = :none if options[:orm] == :merb_default # FIXME: temporary until this is fixed in merb-core 
      end
    
      # Inside a template, wraps a block of code properly in modules, keeping the indentation correct
      # TODO: spec me
      def with_modules(modules, options={}, &block)
        indent = options[:indent] || 0
        text = capture(&block)
        modules.each_with_index do |mod, i|
          concat(("  " * (indent + i)) + "module #{mod}\n", block.binding)
        end
        text = text.to_a.map{ |line| ("  " * modules.size) + line }.join
        concat(text, block.binding)
        modules.reverse.each_with_index do |mod, i|
          concat(("  " * (indent + modules.size - i - 1)) + "end # #{mod}\n", block.binding)
        end
      end
    
      def self.source_root
        File.join(File.dirname(__FILE__), 'templates')
      end
    end
    
    class ApplicationGenerator < Generator
      def self.source_root
        File.join(super, 'application')
      end
    end    
    
    class ComponentGenerator < Generator
      def self.source_root
        File.join(super, 'component')
      end
    end
    
    class NamedGenerator < ComponentGenerator
      
      def class_name
        name.camel_case
      end

      def test_class_name
        class_name + "Test"
      end

      def file_name
        class_name.snake_case
      end
      
    end
    
    class ChunkyGenerator < NamedGenerator
      
      def modules
        chunks[0..-2]
      end

      def class_name
        chunks.last
      end

      def full_class_name
        chunks.join('::')
      end

      protected

      def chunks
        name.gsub('/', '::').split('::').map { |c| c.camel_case }
      end
      
    end
    
  end  
  
end