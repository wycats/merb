# make sure we're running inside Merb
if defined?(Merb::Plugins)  
  dependency "haml"
  dependency "merb-haml/template"
  Merb::Plugins.add_rakefiles(File.join(File.dirname(__FILE__) / "merb-haml" / "merbtasks"))

  Merb::BootLoader.after_app_loads do
    require "sass/plugin" if File.directory?(Merb.dir_for(:stylesheet) / "sass")  
  end
end