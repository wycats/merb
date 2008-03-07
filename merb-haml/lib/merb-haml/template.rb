module Merb::Template

  class Haml
    def self.compile_template(path, name, mod)
      path = File.expand_path(path)
      config = (Merb.config[:haml] || {}).inject({}) do |c, (k, v)|
        c[k.to_sym] = v
        c
      end.merge :filename => path
      template = ::Haml::Engine.new(File.read(path), config)
      template.def_method(mod, name)
      name
    end
  
    module Mixin
      
      def concat_haml(string, binding)
        haml_buffer(binding).buffer << string
      end
      
    end
    Merb::Template.register_extensions(self, %w[haml])  
  end
end

module Haml
  class Engine

    def def_method(object, name, *local_names)
      method = object.is_a?(Module) ? :module_eval : :instance_eval

      setup = "@_engine = 'haml'"

      object.send(method, "def #{name}(_haml_locals = {}); #{setup}; #{precompiled_with_ambles(local_names)}; end",
                  @options[:filename], 0)
    end
 
  end
end

module Haml::Helpers
  # Gets the buffer object for the haml instance 
  # identified in binding
  def haml_buffer(binding)
    eval("buffer", binding)
  end
end
    