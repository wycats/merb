# TODO: Boot Merb, via the Rack test adapter

$TESTING=true

require 'test/unit'
require 'merb/test/fake_request'
require 'merb/test/request_helper'

class Test::Unit::TestCase
  include Merb::Test::RequestHelper
  # Add more helper methods to be used by all tests here...
end