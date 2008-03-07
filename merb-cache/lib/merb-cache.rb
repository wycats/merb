# make sure we're running inside Merb
if defined?(Merb::Plugins)
  Merb::Plugins.add_rakefiles "merb-cache/merbtasks"
  require "merb-cache/merb-cache"
end
