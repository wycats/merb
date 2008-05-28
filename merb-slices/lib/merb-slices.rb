require 'merb-slices/module'

if defined?(Merb::Plugins)
  
  Merb::Plugins.add_rakefiles "merb-slices/merbtasks"
  
  Merb::Plugins.config[:merb_slices] ||= {}
  
  require "merb-slices/module_mixin"
  require "merb-slices/controller_mixin"
  require "merb-slices/router_ext"
  
  # Enable slice behaviour for any class inheriting from AbstractController.
  # To use this call controller_for_slice in your controller class.
  Merb::AbstractController.send(:include, Merb::Slices::ControllerMixin)
  
  # Load Slice classes before the app's classes are loaded.
  #
  # This allows the application to override/merge any slice-level classes.
  class Merb::Slices::Loader < Merb::BootLoader

    before LoadClasses

    cattr_accessor :slice_paths, :app_paths

    class << self

      # Gather load paths and then load classes from the slice-level
      def run
        self.slice_paths, self.app_paths = [], []
        Merb::Slices.register_slices_from_search_path!
        
        Merb::Slices.each_slice do |slice|
          paths_for_slice, paths_for_app = [], []
          begin
            # for flat apps :application can be a single file - load it here before anything else
            load_file slice.dir_for(:application) if File.file?(slice.dir_for(:application))
            push_paths(slice, paths_for_slice, paths_for_app) # push all relevant paths
            self.slice_paths, self.app_paths = paths_for_slice, paths_for_app
            load_classes slice_paths # load all slice-level paths
            slice.loaded if slice.respond_to?(:loaded) # call hook if available
            Merb.logger.info!("loaded slice '#{slice}' ...")
          rescue => e
            Merb.logger.warn!("failed loading #{slice} (#{e.message})")
          end
        end
      end
    
      # Collect load paths to load from
      #
      # @param slice<Module> Slice module.
      # @param paths_for_slice<Array> Optional array to append slice-level paths to.
      # @param paths_for_app<Array> Optional array to append app-level paths to.
      def push_paths(slice, paths_for_slice = [], paths_for_app = [])
        slice.slice_paths.each do |component, path|
          if File.directory?(component_path = path.first)
            $LOAD_PATH.unshift(component_path) if component.in?(:model, :controller, :lib)
            # slice-level component load path - will be preceded by application/app/component - loaded next by Setup.load_classes
            paths_for_slice << path.first / path.last if path.last
            # app-level component load path (override) path - loaded by BootLoader::LoadClasses
            if (app_glob = slice.app_glob_for(component)) && File.directory?(app_component_dir = slice.app_dir_for(component))
              paths_for_app << app_component_dir / app_glob
              Merb.push_path(:"#{slice.name.snake_case}_#{component}", app_component_dir, app_glob)
            end
          end
        end
        [paths_for_slice, paths_for_app]
      end
      
      # ==== Parameters
      # file<String>:: The file to load.
      def load_file(file)
        Merb::BootLoader::LoadClasses.load_file file
      end
    
      # Load classes from given paths - using path/glob pattern.
      #
      # *paths<Array>::
      #   Array of paths to load classes from - may contain glob pattern
      def load_classes(*paths)
        Merb::BootLoader::LoadClasses.load_classes paths
      end
    
      # Reload the router - takes all_slices into account to load slices at runtime
      def reload_router!
        Merb::BootLoader::LoadClasses.reload_router!
      end
      
    end

  end
  
  # Call initialization method for each registered Slice
  #
  # This is done just before the app's after_load_callbacks are run.
  # The application has been practically loaded completely, letting
  # the callbacks work with what has been loaded.
  class Merb::Slices::Initialize < Merb::BootLoader
  
    before AfterAppLoads
  
    def self.run
      Merb::Slices.each_slice do |slice|
        Merb.logger.info!("initializing slice '#{slice}' ...") 
        slice.init if slice.respond_to?(:init)
      end
    end
  
  end
  
  # Call activation method for each registered Slice
  #
  # This is done right after the app's after_load_callbacks are run.
  # Any settings can be taken into account in the activation step.
  class Merb::Slices::Activate < Merb::BootLoader
  
    after AfterAppLoads
  
    def self.run
      Merb::Slices.each_slice do |slice|
        Merb.logger.info!("activating slice '#{slice}' ...")
        slice.activate if slice.respond_to?(:activate)
      end
    end
  
  end
  
end