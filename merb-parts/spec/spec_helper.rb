require 'rubygems'
require "merb-core"
require File.join( File.dirname(__FILE__), "..", "lib", "merb-parts" )

# Require the fixtures
Dir[File.join(File.dirname(__FILE__), "fixtures", "*/**.rb")].each{|f| require f }

Merb.start :environment => 'test'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end