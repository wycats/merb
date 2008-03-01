$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "spec"

require "merb-builder"
require File.dirname(__FILE__) / "controllers" / "builder"

Merb.start :environment => 'test', :builder => { "indent" => 4 }

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end
