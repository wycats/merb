require "haml"
require "merb-haml/template"

Merb::BootLoader.after_app_loads do
  require "sass/plugin" if File.directory?(Merb.dir_for(:stylesheet) / "sass")  
end