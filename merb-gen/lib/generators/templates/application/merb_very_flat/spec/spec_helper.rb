require "rubygems"
require "spec"
require "merb-core"

Merb::Config.use do |c|
  c[:session_store] = "memory"
end

Merb.start_environment(:testing => true,
                       :adapter => 'runner',
                       :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end
