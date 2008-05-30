module <%= module_name %>
  
  # All Slice code is expected to be namespaced inside this module.
  
  class Application < Merb::Controller
    
    controller_for_slice
    
    private
    
    # Construct a path relative to the public directory
    def public_path_for(type, *segments)
      File.join(slice.public_dir_for(type), *segments)
    end
    
    # Construct an app-level path.
    def app_path_for(type, *segments)
      File.join(slice.app_dir_for(type), *segments)
    end
    
    # Construct a slice-level path
    def slice_path_for(type, *segments)
      File.join(slice.dir_for(type), *segments)
    end
    
  end
  
  class Main < Application
    
    def index
      render
    end
    
  end
  
end