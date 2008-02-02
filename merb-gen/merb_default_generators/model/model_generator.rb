class ModelGenerator < Merb::GeneratorBase
  attr_reader :model_attributes, :model_class_name, :model_file_name
  
  def initialize(args, runtime_args = {})
    @base =                 File.dirname(__FILE__)
    args.unshift(".")  # Need to add this or the files are copied over to 
                       # Merb.root/model_name/app/models/model_name.rb
    super
    
    
    @model_file_name =      args.shift.snake_case
    @model_class_name =     @model_file_name.to_const_string
    @model_attributes =     Hash[*(args.map{|a| a.split(":") }.flatten)]
  end
  
  def manifest
    record do |m|
      @m = m
    
      @assigns = {  :model_file_name  => model_file_name, 
                    :model_attributes => model_attributes,
                    :model_class_name => model_class_name
                  }
                  
      m.dependency "merb_model_test", model_file_name, @assigns
      
      copy_dirs
      copy_files
    
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Datamapper Model stub..

      USAGE: #{spec.name}"
    EOS
  end
      
end