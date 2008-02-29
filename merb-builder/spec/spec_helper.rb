$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "spec"

require "merb-builder"
require File.dirname(__FILE__) / "controllers" / "builder"

Merb.start :environment => 'test', :builder => { "indent" => 4 }

require "merb-core/test/fake_request"
require "merb-core/test/request_helper"
Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end
