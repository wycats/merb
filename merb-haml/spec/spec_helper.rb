$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"

Merb::Plugins.config[:haml] = {"autoclose" => ["foo"]}

require "merb-haml"
require File.dirname(__FILE__) / "controllers" / "haml"

Merb.start :environment => 'test', :adapter => 'runner'

require "merb-core/test/fake_request"
require "merb-core/test/request_helper"
Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end
