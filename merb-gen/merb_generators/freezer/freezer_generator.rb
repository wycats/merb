class FreezerGenerator < Merb::GeneratorBase
  
  def initialize(args, runtime_args = {})
    @base =             File.dirname(__FILE__)
    super
  end
  
  def manifest
    record do |m|
      @m = m
      @assigns = {}
      copy_dirs
      m.file "script/frozen-merb", "script/frozen-merb", :chmod => 0755, :shebang => DEFAULT_SHEBANG
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a frozen-merb script that runs merb from framework/ or gems/

      USAGE: #{spec.name} frozen-merb
    EOS
  end
end