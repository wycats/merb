require "merb-gen/helpers"
require "merb-gen/base"

class MailControllerGenerator < Merb::GeneratorBase
  
  attr_reader :controller_class_name, 
              :controller_file_name, 
              :controller_base_path,
              :controller_modules,
              :full_controller_const
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super
    name = args.shift
    @controller_file_name   = name.snake_case.gsub("::", "/")
    
    # Need to setup the directories
    unless @controller_file_name == File.basename(@controller_file_name)
      @controller_base_path   = controller_file_name.split("/")[0..-2].join("/") 
    end
    
    @controller_modules     = @controller_file_name.to_const_string.split("::")[0..-2]
    @controller_class_name  = @controller_file_name.to_const_string.split("::").last
    
    @full_controller_const = ((@controller_modules.dup || []) << @controller_class_name).join("::")
  end
  
  def manifest
    record do |m|
      @m = m
      
      # Create the controller directory
      m.directory File.join("app/mailers", controller_base_path) if controller_base_path
      
      @assigns =  {
                    :controller_modules    => controller_modules,
                    :controller_class_name => controller_class_name,
                    :controller_file_name  => controller_file_name,
                    :controller_base_path  => controller_base_path,
                    :full_controller_const => full_controller_const
                  }
      
      copy_dirs
      copy_files
      
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Merb mail controller stub.

      USAGE: #{spec.name} mail_controller_name"
    EOS
  end  
  
end