require "merb-gen/helpers"
require "merb-gen/base"

class VeryThinSliceGenerator < Merb::GeneratorBase
  
  attr_reader :underscored_name, :module_name
  
  def initialize(args, runtime_options = {})
    @base = File.dirname(__FILE__)
    @name = args.first
    @underscored_name = @name.gsub('-', '_')
    @module_name = @underscored_name.to_const_string
    raise 'Invalid Slice name' if @module_name.include?('::')
    super
    @destination_root = @name    
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Merb slice stub.

      USAGE: #{spec.name} slice your-lowercase-slice-name"
    EOS
  end

end