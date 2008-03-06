$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require "rubygems"
require "merb-core"
require "assistance"

require "merb-cache"
require File.dirname(__FILE__) / "controller"

class Merb::AbstractController
def capture(*args, &block)
    send("capture_#{@_engine}", *args, &block)
  end

  def concat(str, binding)
    send("concat_#{@_engine}", str, binding)
  end
end

require "merb-haml"

def set_database_adapter(adapter)
  config_file = File.dirname(__FILE__) / "config/database.yml"
  config = IO.read(config_file)
  config.gsub!(/:adapter:\s+.*$/, ":adapter: #{adapter}")
  File.open(config_file, "w+") do |c| c.write(config) end
end

def use_cache_store(store, orm = nil)
  Merb::Plugins.config[:merb_cache] = {
    :store => store,
    :cache_directory => File.dirname(__FILE__) / "cache_data",
    #:cache_html_directory => File.dirname(__FILE__) / "cache_data",
  }
  case store
  when "file"
    FileUtils.rm_f(Dir.glob(File.dirname(__FILE__) / "cache_data/*"))
  when "memory"
  when "memcache"
    require "memcache"
  when "database"
    FileUtils.rm_f(Dir.glob(File.dirname(__FILE__) / "*.sqlite3"))
    case orm
    when "datamapper"
      Merb.environment = "test"
      Merb.logger = Merb::Logger.new("log/merb_test.log")
      set_database_adapter("sqlite3")
      require "merb_datamapper"
    when "activerecord"
      Merb.logger = Merb::Logger.new("log/merb_test.log")
      set_database_adapter("sqlite3")
      require "merb_activerecord"
    when "sequel"
      set_database_adapter("sqlite")
      require "merb_sequel"
    else
      raise "Unknown orm: #{orm}"
    end
  else
    raise "Unknown cache store: #{store}"
  end
end

store = "file"
case ENV["STORE"] || store
when "file"
  use_cache_store "file"
when "memory"
  use_cache_store "memory"
when "memcache"
  use_cache_store "memcache"
when "datamapper"
  use_cache_store "database", "datamapper"
when "sequel"
  use_cache_store "database", "sequel"
when "activerecord"
  use_cache_store "database", "activerecord"
else
  puts "Invalid cache store: #{ENV["store"]}"
  exit
end

Merb.start :environment => "test", :adapter => "runner"

require "merb-core/test/fake_request"
require "merb-core/test/request_helper"
Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper  
end
