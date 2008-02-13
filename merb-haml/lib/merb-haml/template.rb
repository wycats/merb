module Merb::Template

  class Haml
    def self.compile_template(path, name, mod)
      path = File.expand_path(path)
      config = (Merb::Plugins.config[:haml] || {}).inject({}) do |c, (k, v)|
        c[k.to_sym] = v
        c
      end.merge :filename => path
      template = ::Haml::Engine.new(File.read(path), config)
      template.def_method(mod, name)
      name    
    end
  
    module Mixin
      def self.included(mod)
        mod.alias_method :capture, :capture_haml      
      end
    
      def _buffer( binding )
        @_buffer = eval( "buffer.buffer", binding )
      end
    end
    Merb::Template.register_extensions(self, %w[haml])  
  end
end
