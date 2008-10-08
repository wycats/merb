# make sure we're running inside Merb
if defined?(Merb::Plugins)
  require 'extlib'
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
    require 'merb_auth-core/strategy'
    require 'merb_auth-core/session_mixin'
    require 'merb_auth-core/authentication'
    require 'merb_auth-core/errors'
     require 'merb_auth-core/redirection'
    require 'merb_auth-core/authenticated_helper'
   
    Merb::Controller.send(:include, Merb::AuthenticatedHelper)
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
  
  Merb::Plugins.add_rakefiles "merb_auth-core/merbtasks"
  
end