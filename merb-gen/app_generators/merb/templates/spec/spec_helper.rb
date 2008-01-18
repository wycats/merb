Merb.environment="test"
$TESTING=true

# TODO: Boot Merb, via the Test Rack adapter

require 'merb/test/fake_request'
require 'merb/test/request_helper'

Spec::Runner.configure do |config|
  config.include(Merb::Test::RequestHelper)
end