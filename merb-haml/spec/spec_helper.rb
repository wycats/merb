$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "spec"

require "merb-haml"
require File.dirname(__FILE__) / "controllers" / "haml"

Merb::Plugins.config[:haml] = { "autoclose" => ["foo"] }
Merb.start :environment => 'test'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end
