require File.join(File.dirname(__FILE__), "helpers")

class Merb::GeneratorBase < RubiGen::Base
  include Merb::GeneratorHelpers
  attr_reader :name, :base, :choices, :assigns, :m
  
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name']) unless defined?(DEFAULT_SHEBANG)
  
  default_options   :shebang => DEFAULT_SHEBANG
  
  def initialize(args, runtime_options = {})
    super
    usage if args.empty?
    self.class.use_component_sources! Merb.generator_scope
    @destination_root = Dir.pwd
    @choices ||= []
  end

  def manifest
    record do |m|
      @m = m
      
      options["spec"] = true unless options["test"]

      # Set directories that should be optional based on command-line args
      @choices = %w(test spec)
      
      # Set the assigns that should be used for path-interpolation and building templates
      @assigns = {:base_name => File.basename(@name), :test_type => options["spec"] ? "rspec" : "test_unit"}
      
      FileUtils.mkdir_p @name 
      copy_dirs
      copy_files

      display_framework_selections
    end
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Merb plugin stub.

      USAGE: #{spec.name} --generate-plugin path"
    EOS
  end

  def add_options!(opts)
    opts.on("-S", "--[no-]spec", "Generate with RSpec") {|s| @options["spec"] = true}
    opts.on("-T", "--[no-]test", "Generate with Test::Unit") {|t| @options["test"] = true}
  end
    
  def display_framework_selections
    puts
    puts "Your app will use the #{@assigns[:test_type]} test framework."
    if Gem.cache.search("merb_#{@assigns[:test_type]}").size == 0
      puts "You need to install the merb_#{@assigns[:test_type]} gem."
    end
    puts
  end
end
