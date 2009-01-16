$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
gem('merb-core')
require 'merb-core'
require 'merb-core/test'
require 'merb-core/test/helpers'

require File.join( File.dirname(__FILE__), "..", "lib", 'merb_datamapper')

Merb.start :environment => 'test', :adapter => 'runner',
  :session_store => 'datamapper', :merb_root => File.dirname(__FILE__),
  :log_level => :debug

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
end

Merb::Router.prepare do
  default_routes
end

class Application < Merb::Controller
end


require File.join( File.dirname(__FILE__), 'datamapper_id_map_controller')
require File.join( File.dirname(__FILE__), 'datamapper_session_controller')
require File.join( File.dirname(__FILE__), 'datamapper_model')

DataMapper.setup(:default, 'sqlite3::memory:')
DataObjects::Sqlite3.logger = Merb.logger
DataMapper.auto_migrate!
Post.create(:title => 'foo')
