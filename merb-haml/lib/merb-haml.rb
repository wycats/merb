# make sure we're running inside Merb
if defined?(Merb::Plugins)  
  require "haml"
  require "merb-haml/template"
  Merb::Plugins.add_rakefiles(File.join(File.dirname(__FILE__) / "merb-haml" / "merbtasks"))

  Merb::BootLoader.after_app_loads do
    if File.directory?(Merb.dir_for(:stylesheet) / "sass")
      require "sass/plugin" 
      Sass::Plugin.options = Merb::Config[:sass] if Merb::Config[:sass]
    end
  end
  
  # Hack because Haml uses symbolize_keys
  class Hash
    def symbolize_keys!
      self
    end
  end
  
  generators = File.join(File.dirname(__FILE__), 'generators')
  Merb.add_generators generators / "resource_controller"
  Merb.add_generators generators / "controller"
  Merb.add_generators generators / "layout"
  
end