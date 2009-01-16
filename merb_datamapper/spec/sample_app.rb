$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'merb-core'
require 'merb_datamapper'

class Application < Merb::Controller
end

class IdentityMapTest < Application
  def index
    if (Post.get(1).object_id == Post.first(:id => 1).object_id)
      "true"
    else
      "false"
    end
  end
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
end

Merb::Router.prepare do
  match('/id_map').to(:controller => 'identity_map_test', :action =>'index')
end

Merb::BootLoader.after_app_loads do
  DataMapper.setup(:default, 'sqlite3::memory:')
  repository(:default).auto_migrate!
  Post.create(:title => 'A test post')
end

Merb.start_environment(:environment => 'test', :adapter => 'runner', :log_level => :debug)
