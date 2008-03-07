require "merb-cache/cache-action"
require "merb-cache/cache-page"
require "merb-cache/cache-fragment"

class Merb::Cache
  attr_reader  :config, :store

  class Store
    class NotFound < Exception
      def initialize(cache_store)
        super("cache_store (#{cache_store}) not found (not implemented?)")
      end
    end
  end

  def start
    @config = Merb::Plugins.config[:merb_cache]
    @config[:cache_html_directory] ||= Merb.dir_for(:public) / "cache"
    require "merb-cache/cache-store/#{@config[:store]}"
    @store = Merb::Cache::Store.new
    Merb.logger.info("Using #{@config[:store]} cache")
  rescue LoadError
    raise Merb::Cache::Store::NotFound, @config[:store].inspect
  end

  def expire_key_for(o, controller, controller_based = false)
    key = ""
    if o.is_a? Hash
      case
      when key = o[:key]
      when action = o[:action]
        controller = o[:controller] || controller
        key = "/#{controller}/#{action}"
      when match = o[:match]
        key = match
      end
      if _params = o[:params]
        key += "/" + _params.join("/")
      end
      yield key, !o[:match].nil?
    else
      yield controller_based ? "/#{controller}/#{o}" : o, false
    end
    true
  end

  def key_for(o, controller, controller_based = false)
    key = ""
    if o.is_a? Hash
      case
      when key = o[:key]
      when action = o[:action]
        controller = o[:controller] || controller
        key = "/#{controller}/#{action}"
      end
      if _params = o[:params]
        key += "/" + _params.join("/")
      end
    else
      key = controller_based ? "/#{controller}/#{o}" : o
    end
    key
  end

  module ControllerInstanceMethods
    def expire_all
      Merb::Controller._cache.store.expire_all
    end
  end
end

module Merb #:nodoc:
  class Controller #:nodoc:
    cattr_reader :_cache
    @@_cache = Merb::Cache.new
    include Merb::Cache::ControllerInstanceMethods
    class << self #:nodoc:
      include Merb::Cache::ControllerClassMethods
    end
  end
end

Merb::BootLoader.after_app_loads do
  Merb::Controller._cache.start
end

Merb::Plugins.config[:merb_cache] = {
  :cache_html_directory => Merb.dir_for(:public) / "cache",

  #:store => "database",
  #:table_name => "merb_cache",

  :store => "file",
  :cache_directory => Merb.root_path("tmp/cache"),

  #:store => "memcache",
  #:host => "127.0.0.1:11211",
  #:namespace => "merb_cache",

  #:store => "memory",
  # store could be: file, memcache, memory, database, ...
}
