require 'merb-slices/module'

if defined?(Merb::Plugins)
  
  Merb::Plugins.add_rakefiles "merb-slices/merbtasks"
  
  Merb::Plugins.config[:merb_slices] ||= {}
  
  require "merb-slices/controller"
  require "merb-slices/router_ext"
  
  # Load Slice classes before the app's classes are loaded.
  #
  # This allows the application to override/merge any slice-level classes.
  class Merb::Slices::Loader < Merb::BootLoader

    before LoadClasses

    cattr_accessor :load_paths

    def self.run
      self.load_paths = []
      Merb::Slices.each_slice do |module_name, path|
        mod = Object.full_const_get(module_name) rescue nil
        if mod
          # For flat apps :application can be a single file
          Merb::BootLoader::LoadClasses.send(:load_file, mod.dir_for(:application)) if File.file?(mod.dir_for(:application))
          push_paths(self.load_paths, module_name, path)
        end
      end
      Merb::Slices.each_slice { |module_name, path| push_paths(module_name, path) }
      load_classes_from(self.load_paths)
    end
    
    # Add load paths (as pairs of [path, glob]) to load from
    #
    # @param module_name<String> Slice module name.
    # @param slice_root<String> Slice root path.
    # @param paths<Array[Array]> 
    #   Array to append pairs of [path, glob] to - defaults to self.load_paths
    # @param app_paths<Array> 
    #   Optional array to append pairs of app-level [path, glob] to.
    def self.push_paths(module_name, slice_root, paths = self.load_paths, app_paths = [])
      mod = Object.full_const_get(module_name) rescue nil
      return unless mod
      mod.slice_paths.each do |component, path|
        if File.directory?(component_path = path.first)
          $LOAD_PATH.unshift(component_path) if component.in?(:model, :controller, :lib)
          # slice-level component load path - will be preceded by application/app/component - loaded next by Setup.load_classes_from
          paths.push(path) if path[1]
          # app-level component load path (override) path - loaded by BootLoader::LoadClasses
          if (app_glob = mod.app_glob_for(component)) && File.directory?(app_component_dir = mod.app_dir_for(component))
            app_paths << [app_component_dir, app_glob]
            Merb.push_path(:"#{module_name.snake_case}_#{component}", app_component_dir, app_glob)
          end
        end
      end
    end

    # Load classes from given paths - using glob pattern
    #
    # @param paths<Array[Array]> 
    #   Array of [path, glob] pairs to load classes from - defaults to self.load_paths
    def self.load_classes_from(paths = self.load_paths)
      Merb.logger.info!("loading classes for all registered slices ...")
      orphaned_classes = []
      paths.each do |path, glob|
        Dir[path / glob].each do |file|
          begin
            Merb::BootLoader::LoadClasses.send(:load_file, file)
          rescue NameError => ne
            orphaned_classes.unshift(file)
          end
        end
      end
      Merb::BootLoader::LoadClasses.send(:load_classes_with_requirements, orphaned_classes)
    end
    
    # Reload the router - takes all_slices into account to load slices at runtime
    def self.reload_router!
      if File.file?(router_file = Merb.dir_for(:router) / Merb.glob_for(:router))
        Merb::BootLoader::LoadClasses.send(:load_file, router_file)
      end
    end

  end
  
  # Call initialization method for each registered Slice.
  #
  # This is done just before the app's after_load_callbacks are run.
  # The application has been practically loaded completely, letting
  # the callbacks work with what has been loaded.
  class Merb::Slices::Initialize < Merb::BootLoader
  
    before AfterAppLoads
  
    def self.run
      Merb::Slices.each_slice do |module_name, slice_root|
        Merb.logger.info!("initializing slice '#{module_name}' ...") 
        mod = Object.full_const_get(module_name) rescue nil
        mod.init if mod && mod.respond_to?(:init)
      end
    end
  
  end
  
  # Call activation method for each registered Slice.
  #
  # This is done right after the app's after_load_callbacks are run.
  # Any settings can be taken into account in the activation step.
  class Merb::Slices::Activate < Merb::BootLoader
  
    after AfterAppLoads
  
    def self.run
      Merb::Slices.each_slice do |module_name, slice_root|
        Merb.logger.info!("activating slice '#{module_name}' ...")
        mod = Object.full_const_get(module_name) rescue nil
        mod.activate if mod && mod.respond_to?(:activate)
      end
    end
  
  end
  
end