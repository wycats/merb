class MerbModelTestGenerator < Merb::GeneratorBase
  attr_reader :model_attributes, :model_class_name, :model_file_name
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super    
    @model_file_name  = runtime_args[:model_file_name]
    @model_attributes = runtime_args[:model_attributes]
    @model_class_name = runtime_args[:model_class_name]

  end
  
  def manifest
    record do |m|
      @m = m
    
      @assigns = {  :model_file_name  => model_file_name, 
                    :model_attributes => model_attributes,
                    :model_class_name => model_class_name
                  }
      copy_dirs
      copy_files
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a basic rSpec model spec stub.

      USAGE: #{spec.name}"
    EOS
  end
      
end