$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require "merb-core"
require "merb-action-args"
require File.dirname(__FILE__) / "controllers" / "action-args"

Merb.start :environment => 'test'

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end