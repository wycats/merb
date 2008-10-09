# make sure we're running inside Merb
if defined?(Merb::Plugins)
  require 'extlib'
  
  
  require 'merb-auth-core/authentication'
  require 'merb-auth-core/strategy'
  require 'merb-auth-core/session_mixin'
  require 'merb-auth-core/errors'
  require 'merb-auth-core/redirection'
  require 'merb-auth-core/authenticated_helper'
  require 'merb-auth-core/customizations'
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application 
    Merb::Controller.send(:include, Merb::AuthenticatedHelper)
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "merb-auth-core/merbtasks"
  
end