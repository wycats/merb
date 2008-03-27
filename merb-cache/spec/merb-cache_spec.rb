require File.dirname(__FILE__) + "/spec_helper"

Merb::Router.prepare do |r|
  r.default_routes
  r.match("/").to(:controller => "cache_controller", :action =>"index")
end

CACHE = CacheController.new(Merb::Test::RequestHelper::FakeRequest.new)
CACHE.expire_all

puts "Using #{CACHE._cache.store.cache_store_type.inspect} store"

require File.dirname(__FILE__) + "/merb-cache-fragment_spec"
require File.dirname(__FILE__) + "/merb-cache-action_spec"
require File.dirname(__FILE__) + "/merb-cache-page_spec"
