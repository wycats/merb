class ResourceGenerator < Merb::GeneratorBase
  
  attr_reader :name, :class_name, :file_name, :provided_args
  
  def initialize(runtime_args, runtime_options = {})
    @base =             File.dirname(__FILE__)
    super
    @provided_args = runtime_args
  end

  def manifest
    record do |m|
      @m = m
      
      #singularize the model & pluralize the name of the controller
      model_args = provided_args.dup
      controller_args = provided_args.dup
      
      # normalize the model_args
      model_args[0] = model_args.first.snake_case.gsub("::", "/").split("/").last.singularize
      
      
      controller_args[0] = controller_args.first.pluralize
      
      m.dependency "model", model_args, options.dup
      m.dependency "resource_controller", controller_args, options.dup
    end
  end
  
  protected
      def banner
        <<-EOS
  Creates a full resource.  This includes:

      Model: A model class 
      Migration: if required
      Model Test or Spec stub
      Resource Controller and views
      Controller Test or Spec stubs

      Example

      merb-gen resource post title:string content:text created_at:datetime

  USAGE: #{$0} #{spec.name} name"
  EOS
      end
end