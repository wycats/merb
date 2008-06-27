$TESTING=true
require 'rubygems'
require 'merb-core'


# TODO: Boot Merb, via the Test Rack adapter
Merb.start :environment => (ENV['MERB_ENV'] || 'test'),
           :merb_root  => File.join(File.dirname(__FILE__), ".." )


class Test::Unit::TestCase
  include Merb::Test::RequestHelper
  # Add more helper methods to be used by all tests here...
end