module <%= module_name %>
  
  # All Slice code is expected to be namespaced inside this module.
  
  class Application < Merb::Controller
    
    controller_for_slice
    
    layout(Merb::Slices::config[:<%= underscored_name %>][:layout]) if Merb::Slices::config[:<%= underscored_name %>].key?(:layout)
    
    private
    
    # Construct a path relative to the public directory
    def public_path_for(type, *segments)
      File.join(::<%= module_name %>.public_dir_for(type), *segments)
    end
    
    # Construct an app-level path.
    def app_path_for(type, *segments)
      File.join(::<%= module_name %>.app_dir_for(type), *segments)
    end
    
    # Construct a slice-level path
    def slice_path_for(type, *segments)
      File.join(::<%= module_name %>.dir_for(type), *segments)
    end
    
  end
  
  class Main < Application
    
    def index
      render
    end
    
  end
  
end