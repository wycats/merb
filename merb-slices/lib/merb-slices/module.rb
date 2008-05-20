module Merb
  module Slices
    
    # Register a Slice by its gem/lib path
    #
    # This is referenced from gems/<slice-gem-x.x.x>/lib/<slice-gem>.rb
    # Which gets loaded for any gem. The name of the file is used
    # to extract the Slice module name.
    #
    # @param slice_file<String> The path of the gem 'init file'
    #
    # @return <Module> The Slice module that has been setup.
    #
    # @example Merb::Slices::register(__FILE__)
    def self.register(slice_file)
      identifier  = File.basename(slice_file, '.rb')
      module_name = identifier.gsub('-', '_').camel_case
      slice_path  = File.expand_path(File.dirname(slice_file) + '/..')
      Merb.logger.info!("registered slice '#{module_name}' located at #{slice_path}")
      self.paths[module_name] = slice_path
      mod = setup_module(module_name)
      mod.identifier = identifier
      mod.root = slice_path
      mod
    end
    
    # Unregister a Slice module at runtime
    #
    # @param <Module> The Slice module to unregister.
    def self.unregister(slice_module)
      module_name = slice_module.to_s
      if self.paths.delete(module_name)
        Object.send(:remove_const, module_name) rescue nil
        unless Object.const_defined?(module_name)
          Merb.logger.info!("unregistered slice #{slice_module}")
          Merb::Slices::Setup.reload_router!
        end
      end
    end
    
    # @return <Hash>
    #   The configuration loaded from Merb.root / "config/slices.yml" or, if
    #   the load fails, an empty hash.
    def self.config
      @config ||= File.exists?(Merb.root / "config" / "slices.yml") ? YAML.load(File.read(Merb.root / "config" / "slices.yml")) || {} : {}
    end
    
    # All registered Slice module names
    #
    # @return <Array> A sorted array of all slice modules.
    def self.slices
      self.paths.keys.sort
    end
    
    # Check whether a Slice exists
    # 
    # @param <#to_s> The slice module to check for.
    def self.exists?(module_name)
      self.slices.include?(module_name.to_s) && Object.const_defined?(module_name.to_s)
    end
    
    # A lookup for finding a Slice module's path
    #
    # @return <Hash> A Hash mapping module names to root paths.
    def self.paths
      @paths ||= {}
    end
  
    # Iterate over all registered slices
    #
    # By default iterates alphabetically over all registered modules. 
    # If Merb::Plugins.config[:merb_slices][:queue] is set, only the
    # defined modules are loaded in the given order. This can be
    # used to selectively load slices, and also maintain load-order
    # for slices that depend on eachother.
    #
    # @yield Iterate over known slices and pass name and root path.
    # @yieldparam module_name<String>  The Slice module name.
    # @yieldparam path<String> The root path of the Slice.
    def self.each_slice(&block)
      loadable_slices = Merb::Plugins.config[:merb_slices].key?(:queue) ? Merb::Plugins.config[:merb_slices][:queue] : self.slices
      loadable_slices.each do |module_name|
        next unless self.paths.key?(module_name)
        block.call(module_name, self.paths[module_name])
      end
    end
    
    private
    
    # Prepare a module to be a proper Slice module
    #
    # @param module_name<#to_s>:: The name of the module to prepare
    #
    # @return <Module> The module that has been setup
    def self.setup_module(module_name)
      Object.make_module(module_name)
      mod = Object.full_const_get(module_name)
      mod.meta_class.module_eval do
        
        attr_accessor :identifier, :root, :slice_paths, :app_paths
        attr_accessor :description, :version, :author
        
        # Stub initialization hook - runs before AfterAppLoads BootLoader.
        def init; end
        
        # Stub activation hook - runs after AfterAppLoads BootLoader.
        def activate; end
        
        # Stub deactivation method - not triggered automatically.
        def deactivate!; end
        
        # Stub to setup routes inside the host application.
        def setup_router(scope); end
        
        # @return <Hash> The load paths which make up the gem-level structure.
        def slice_paths
          @slice_paths ||= Hash.new { [self.root] }
        end
        
        # @return <Hash> The load paths which make up the app-level structure.
        def app_paths
          @app_paths ||= Hash.new { [Merb.root] }
        end
        
        # @param *path<#to_s>
        #   The relative path (or list of path components) to a directory under the
        #   root of the application.
        #
        # @return <String> The full path including the root.
        def root_path(*path) File.join(self.root, *path) end
        
        # Retrieve the absolute path to a gem-level directory.
        #
        # @param type<Symbol> The type of path to retrieve directory for, e.g. :view.
        #
        # @return <String> The absolute path for the requested type.
        def dir_for(type) self.slice_paths[type].first end
        
        # @param type<Symbol> The type of path to retrieve glob for, e.g. :view.
        #
        # @return <String> The pattern with which to match files within the type directory.
        def glob_for(type) self.slice_paths[type][1] end

        # Retrieve the absolute path to a app-level directory. 
        #
        # @param type<Symbol> The type of path to retrieve directory for, e.g. :view.
        #
        # @return <String> The directory for the requested type.
        def app_dir_for(type) self.app_paths[type].first end
        
        # @param type<Symbol> The type of path to retrieve glob for, e.g. :view.
        #
        # @return <String> The pattern with which to match files within the type directory.
        def app_glob_for(type) self.app_paths[type][1] end
        
        # Retrieve the relative path to a public directory.
        #
        # @param type<Symbol> The type of path to retrieve directory for, e.g. :view.
        #
        # @return <String> The relative path to the public directory for the requested type.
        def public_dir_for(type)
          dir = self.app_dir_for(type).relative_path_from(Merb.dir_for(:public)) rescue '.'
          dir == '.' ? '/' : "/#{dir}"
        end
        
        # This is the core mechanism for setting up your gem-level layout.
        #
        # @param type<Symbol> The type of path being registered (i.e. :view)
        # @param path<String> The full path
        # @param file_glob<String>
        #   A glob that will be used to autoload files under the path. Defaults to "**/*.rb".
        def push_path(type, path, file_glob = "**/*.rb")
          enforce!(type => Symbol)
          slice_paths[type] = [path, file_glob]
        end
        
        # Removes given types of application components
        # from gem-level load path this slice uses for autoloading.
        #
        # @param *args<Array[Symbol]> Components names, for instance, :views, :models
        def remove_paths(*args)
          args.each { |arg| self.slice_paths.delete(arg) }
        end
        
        # This is the core mechanism for setting up your app-level layout.
        #
        # @param type<Symbol> The type of path being registered (i.e. :view)
        # @param path<String> The full path
        # @param file_glob<String>
        #   A glob that will be used to autoload files under the path. Defaults to "**/*.rb".
        def push_app_path(type, path, file_glob = "**/*.rb")
          enforce!(type => Symbol)
          app_paths[type] = [path, file_glob]
        end
        
        # Removes given types of application components
        # from app-level load path this slice uses for autoloading.
        #
        # @param *args<Array[Symbol]> Components names, for instance, :views, :models
        def remove_app_paths(*args)
          args.each { |arg| self.app_paths.delete(arg) }
        end
        
        # This sets up the default gem-level and app-level structure.
        # 
        # You can create your own structure by implementing setup_structure and
        # using the push_path and push_app_paths. By default this setup matches
        # what the merb-gen slice generator creates.
        def setup_default_structure!
          self.push_path(:application, self.root / 'app')
          self.push_app_path(:application, Merb.root / 'slices' / self.identifier / 'app')
          
          [:view, :model, :controller, :helper, :mailer, :part, :lib].each do |component|
            self.push_path(component, dir_for(:application) / "#{component}s")
            self.push_app_path(component, app_dir_for(:application) / "#{component}s")
          end
          
          self.push_path(:public, self.root / 'public', nil)
          self.push_app_path(:public, Merb.root / 'public' / 'slices' / self.identifier, nil)
          
          [:stylesheet, :javascript, :image].each do |component|
            self.push_path(component, dir_for(:public) / "#{component}s", nil)
            self.push_app_path(component, app_dir_for(:public) / "#{component}s", nil)
          end
        end       
        
      end
      mod
    end
    
  end
end