require "merb-gen/helpers"
require "merb-gen/base"

class MerbVeryFlatGenerator < Merb::GeneratorBase
  attr_reader :app_file_name
  
  def initialize(args, runtime_options = {})
    @base = File.dirname(__FILE__)
    @name = args.first
    @app_file_name = File.basename(@name).snake_case
    super
    @destination_root = @name
  end
  
  def manifest
    record do |m|

      @m = m
    
      @assigns = { :app_file_name  => app_file_name }
      
      FileUtils.mkdir_p @name                  
      copy_dirs
      copy_files
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a very flat Merb application stub.

      USAGE: #{spec.name} path --very-flat"
    EOS
  end

end