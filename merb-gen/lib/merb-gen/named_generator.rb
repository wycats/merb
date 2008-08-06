module Merb
  module Generators

    class NamedGenerator < Generator
      
      # NOTE: Currently this is not inherited, it will have to be declared in each generator
      # that inherits from this.
      first_argument :name, :required => true
      
      def class_name
        name.gsub('-', '_').camel_case
      end

      def test_class_name
        class_name + "Test"
      end

      def file_name
        name.snake_case
      end

      def symbol_name
        file_name.gsub('-', '_')
      end

    end
 
  end
end