require "merb-gen/helpers"
require "merb-gen/base"

class MerbPluginGenerator < Merb::GeneratorBase
  
  attr_reader :choices
  def initialize(args, runtime_options = {})
    @base = File.dirname(__FILE__)
    @name = args.first
    super
    @choices << "bin"
    @destination_root = @name    
  end
  
  def add_options!(opts)
    opts.on("-B", "--[no-]binary", "Generate a binary directory") {|s| @options["bin"] = true}
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Merb plugin stub.

      USAGE: #{spec.name} --generate-plugin path"
    EOS
  end

end
