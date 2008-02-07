$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require "merb-core"
require "merb-action-args"
require File.dirname(__FILE__) / "controllers" / "action-args"

Merb.start :environment => "test", :adapter => "runner"

require "merb-core/test/fake_request"
require "merb-core/test/request_helper"
Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end