module Merb
  module Generators

    class NamespacedGenerator < NamedGenerator
      
      # NOTE: Currently this is not inherited, it will have to be declared in each generator
      # that inherits from this.
      first_argument :name, :required => true
      
      def modules
        chunks[0..-2]
      end

      def class_name
        chunks.last
      end

      def full_class_name
        chunks.join('::')
      end
      
      def base_path
        File.join(*snake_cased_chunks[0..-2])
      end

      protected

      def snake_cased_chunks
        chunks.map { |c| c.snake_case }
      end

      def chunks
        name.gsub('/', '::').split('::').map { |c| c.camel_case }
      end
      
    end
  
  end
end