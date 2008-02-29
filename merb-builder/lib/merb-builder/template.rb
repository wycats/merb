module Merb::Template

  class Builder
    def self.compile_template(path, name, mod)
      path = File.expand_path(path)
      method = mod.is_a?(Module) ? :module_eval : :instance_eval
      mod.send(method, %{
        def #{name}
          @_engine = 'builder'
          config = (Merb.config.builder || {}).inject({}) do |c, (k, v)|
            c[k.to_sym] = v
            c
          end
          xml = ::Builder::XmlMarkup.new(config)
          self.instance_eval %{#{File.read(path)}}
          xml.target!
        end
      })
      
      name    
    end
  
    module Mixin; end
    Merb::Template.register_extensions(self, %w[builder]) 
  end
end
