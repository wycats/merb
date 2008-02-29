class MerbResourceControllerTestGenerator < Merb::GeneratorBase
  attr_reader :controller_modules, 
              :controller_class_name, 
              :controller_file_name,
              :controller_base_path,
              :full_controller_const
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super    
    @args = args
    @runtime_args = runtime_args
  end
  
  def manifest
    record do |m|
      @m = m
    
      m.dependency "merb_controller_test", @args, @runtime_args
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a basic Test::Unit Functional test stub.

      USAGE: #{spec.name}"
    EOS
  end
end