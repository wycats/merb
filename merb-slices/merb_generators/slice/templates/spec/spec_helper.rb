require 'rubygems'
require 'merb-core'
require 'spec'

SLICE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Merb::BootLoader.before_app_loads { require(File.join(SLICE_ROOT, 'lib', '<%= base_name %>')) }

Merb.start_environment(
  :testing => true, 
  :adapter => 'runner', 
  :environment => ENV['MERB_ENV'] || 'test',
  :merb_root => File.join(File.dirname(__FILE__), '..')
)

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end