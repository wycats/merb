require "merb-gen/helpers"
require "merb-gen/base"

class MerbFlatGenerator < Merb::GeneratorBase
  
  def initialize(args, runtime_options = {})
    @base = File.dirname(__FILE__)
    @name = args.first
    super
    @destination_root = @name
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a flat Merb application stub.

      USAGE: #{spec.name} path --flat"
    EOS
  end

end