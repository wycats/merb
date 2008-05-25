class ModelGenerator < Merb::GeneratorBase
  attr_reader :model_attributes, :model_class_name, :model_file_name
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super
    @model_file_name =  args.shift.snake_case
    @model_class_name = @model_file_name.to_const_string
    @model_attributes = Hash[*(args.map{|a| a.split(":") }.flatten)]
  end
  
  def manifest
    record do |m|

      @m = m
    
      @assigns = {  
                    :model_file_name  => model_file_name, 
                    :model_attributes => model_attributes,
                    :model_class_name => model_class_name
                  }
                        
      copy_dirs
      copy_files

      m.dependency "merb_model_test", [model_file_name], @assigns
    
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a basic Merb model stub.

      USAGE: #{spec.name} my_model property1:type property1:type
    EOS
  end
      
end