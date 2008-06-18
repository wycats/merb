module Merb::Template

  class Builder

    # Defines a method for calling a specific Builder template.
    #
    # ==== Parameters
    # path<String>:: Path to the template file.
    # name<~to_s>:: The name of the template method.
    # mod<Class, Module>::
    #   The class or module wherein this method should be defined.
    def self.compile_template(io, name, mod)
      path = File.expand_path(io.path)
      method = mod.is_a?(Module) ? :module_eval : :instance_eval
      mod.send(method, %{
        def #{name}
          @_engine = 'builder'
          config = (Merb.config[:builder] || {}).inject({}) do |c, (k, v)|
            c[k.to_sym] = v
            c
          end
          xml = ::Builder::XmlMarkup.new(config)
          self.instance_eval %{#{io.read}}
          xml.target!
        end
      })
      
      name    
    end
  
    module Mixin
      def _builder_buffer(the_binding)
        @_buffer = eval("xml", the_binding, __FILE__, __LINE__)
      end
      # ==== Parameters
      # *args:: Arguments to pass to the block.
      # &block:: The template block to call.
      #
      # ==== Returns
      # String:: The output of the block.
      #
      # ==== Examples
      # Capture being used in a .html.erb page:
      # 
      #   @foo = capture do
      #     xml.instruct!
      #     xml.foo do
      #       xml.bar "baz"
      #     end
      #     xml.target!
      #   end
      def capture_builder(*args, &block)
        block.call(*args)
      end

      def concat_builder(string, binding)
        _builder_buffer(binding) << string
      end
      
    end
    Merb::Template.register_extensions(self, %w[builder]) 
  end
end
