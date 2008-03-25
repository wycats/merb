require "merb-gen/helpers"
require "merb-gen/base"

class MerbGenerator < Merb::GeneratorBase
  
  def initialize(args, runtime_options = {})
    @base = File.dirname(__FILE__)
    @name = args.first
    super
    @destination_root = @name
  end
  
  protected
  def banner
    <<-EOS.split("\n").map{|x| x.strip}.join("\n")
      Creates a Merb application stub.

      USAGE: #{spec.name} -g path
      
      Set environment variable MERB_ORM=[activerecord|datamapper|sequel]
      to pre-enabled an ORM.
    EOS
  end

  def default_orm?(orm)
    ENV['MERB_ORM'] == orm.to_s
  end
  
  def default_test_suite?(suite)
    return ENV['MERB_TEST_SUITE'] == suite.to_s if ENV['MERB_TEST_SUITE']
    options[suite]
  end

  def display_framework_selections
  end
end
