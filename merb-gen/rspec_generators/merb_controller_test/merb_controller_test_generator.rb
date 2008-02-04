class MerbControllerTestGenerator < Merb::GeneratorBase
  attr_reader :controller_modules, 
              :controller_class_name, 
              :controller_file_name,
              :controller_base_path,
              :full_controller_const
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super    
    @controller_modules     = runtime_args[:controller_modules]
    @controller_class_name  = runtime_args[:controller_class_name]
    @controller_file_name   = runtime_args[:controller_file_name]
    @controller_base_path   = runtime_args[:controller_base_path]
    @full_controller_const  = runtime_args[:full_controller_const]
  end
  
  def manifest
    record do |m|
      @m = m
    
      @assigns = {  
                    :controller_modules         => controller_modules, 
                    :controller_class_name      => controller_class_name,
                    :controller_full_file_path  => controller_file_name,
                    :controller_file_name       => controller_file_name.split("/").last,
                    :controller_base_path       => controller_base_path,
                    :full_controller_const      => full_controller_const
                  }
      
      # make sure the directory is availalbe
      m.directory File.join("spec", "controllers", "#{controller_base_path}")
      m.directory File.join("spec", "helpers", "#{controller_base_path}")
                  
      copy_dirs
      copy_files
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a basic rSpec controller spec stub.

      USAGE: #{spec.name}"
    EOS
  end
      
end