class ResourceControllerGenerator < Merb::GeneratorBase
  
  attr_reader :controller_class_name, 
              :controller_file_name, 
              :controller_base_path,
              :controller_modules,
              :model_args,
              :model_class_name
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    
    super
    name = args.shift
    nfp = name.snake_case.gsub("::", "/")
    nfp = nfp.split("/")
    nfp << (nfp.pop.pluralize)
    @controller_file_name = nfp.join("/")
    
    # Need to setup the directories
    unless @controller_file_name == File.basename(@controller_file_name)
      @controller_base_path   = controller_file_name.split("/")[0..-2].join("/") 
    end
    
    @controller_modules     = @controller_file_name.to_const_string.split("::")[0..-2]
    @controller_class_name  = @controller_file_name.to_const_string.split("::").last
    @model_class_name       = @controller_class_name.singularize
    
    @model_args = [@model_class_name, *args].flatten
  end
  
  def manifest
    record do |m|
      @m = m
      
      # Create the controller directory
      m.directory File.join("app/controllers", controller_base_path) if controller_base_path
      
      # Create the helpers directory
      m.directory File.join("app/helpers", controller_base_path) if controller_base_path
      
      @assigns =  {
                    :controller_modules         => controller_modules,
                    :controller_class_name      => controller_class_name,
                    :controller_file_name       => controller_file_name,
                    :controller_base_path       => controller_base_path,
                    :full_controller_identifier => (controller_modules.dup << controller_class_name).join("::")
                  }
      
      copy_dirs
      copy_files
      
      m.dependency "model", model_args
      # m.dependency "merb_resource_controller_test", [@controller_class_name], @assigns
    end
  end
end