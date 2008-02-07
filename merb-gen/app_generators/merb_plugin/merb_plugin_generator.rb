require "merb-gen/helpers"
require "merb-gen/base"

class MerbPluginGenerator < Merb::GeneratorBase
  
  def initialize(args, runtime_options = {})
    @base = File.dirname(__FILE__)
    @name = args.first
    super
    @destination_root = @name    
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Merb plugin stub.

      USAGE: #{spec.name} --generate-plugin path"
    EOS
  end

end
