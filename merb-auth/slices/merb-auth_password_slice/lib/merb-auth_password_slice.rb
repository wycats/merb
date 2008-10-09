if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  require 'merb-auth-core'
  Merb::Plugins.add_rakefiles "merb-auth_password_slice/merbtasks", "merb-auth_password_slice/slicetasks", "merb-auth_password_slice/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :mauth_password_slice
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:"merb-auth_password_slice"][:layout] ||= :application
  
  # All Slice code is expected to be namespaced inside a module
  module MerbAuthPasswordSlice
    
    # Slice metadata
    self.description = "MerbAuthPasswordSlice is a merb slice that provides basic password based logins"
    self.version = "0.0.1"
    self.author = "Daniel Neighman"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      require 'merb-auth-more/strategies/basic/password_form'
      require 'merb-auth-more/strategies/basic/basic_auth'
      require 'merb-auth-more/strategies/basic/openid'
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      # Load the default strategies
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbAuthPasswordSlice)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :mauth_password_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      # scope.match('/index.:format').to(:controller => 'main', :action => 'index').name(:mauth_password_slice_index)
      scope.match("/login", :method => :put).to(:controller => "sessions", :action => "update").name(:"merb-auth_perform_login")
      scope.match("/logout").to(:controller => "sessions", :action => "destroy").name(:"merb-auth_logout")
    end
    
  end
  
  # Setup the slice layout for MerbAuthPasswordSlice
  #
  # Use MerbAuthPasswordSlice.push_path and MerbAuthPasswordSlice.push_app_path
  # to set paths to mauth_password_slice-level and app-level paths. Example:
  #
  # MerbAuthPasswordSlice.push_path(:application, MerbAuthPasswordSlice.root)
  # MerbAuthPasswordSlice.push_app_path(:application, Merb.root / 'slices' / 'mauth_password_slice')
  # ...
  #
  # Any component path that hasn't been set will default to MerbAuthPasswordSlice.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbAuthPasswordSlice.setup_default_structure!
  
  MaPS = MerbAuthPasswordSlice
  # Add dependencies for other MerbAuthPasswordSlice classes below. Example:
  # dependency "mauth_password_slice/other"
  
end