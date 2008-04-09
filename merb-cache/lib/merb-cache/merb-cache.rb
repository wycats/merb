require "merb-cache/cache-action"
require "merb-cache/cache-page"
require "merb-cache/cache-fragment"

class Merb::Cache
  attr_reader  :config, :store

  class StoreNotFound < Exception #:nodoc:
    def initialize(cache_store)
      super("cache_store (#{cache_store}) not found (not implemented?)")
    end
  end

  DEFAULT_CONFIG = {
    :cache_html_directory => Merb.dir_for(:public) / "cache",

    #:store => "database",
    #:table_name => "merb_cache",

    #:disable => "development", # disable merb-cache in development
    #:disable => true, # disable merb-cache in all environments

    :store => "file",
    :cache_directory => Merb.root_path("tmp/cache"),

    #:store => "memcache",
    #:host => "127.0.0.1:11211",
    #:namespace => "merb_cache",
    #:track_keys => true,

    #:store => "memory",
    # store could be: file, memcache, memory, database, dummy, ...
  }

  # Called in the after_app_loads loop and instantiate the right backend
  #
  # ==== Raises
  # Store#NotFound::
  #   If the cache_store mentionned in the config is unknown
  def start
    @config = DEFAULT_CONFIG.merge(Merb::Plugins.config[:merb_cache] || {})
    if @config[:disable] == true || Merb.environment == @config[:disable]
      config[:store] = "dummy"
    end
    @config[:cache_html_directory] ||= Merb.dir_for(:public) / "cache"
    require "merb-cache/cache-store/#{@config[:store]}"
    @store = Merb::Cache.const_get("#{@config[:store].capitalize}Store").new
    Merb.logger.info("Using #{@config[:store]} cache")
  rescue LoadError
    raise Merb::Cache::StoreNotFound, @config[:store].inspect
  end

  # Compute a cache key and yield it to the given block
  # It is used by the #expire_page, #expire_action and #expire methods.
  #
  # ==== Parameters
  # options<String, Hash>:: The key or the Hash that will be used to build the key
  # controller<String>:: The name of the controller
  # controller_based<Boolean>:: only used by action and page caching
  #
  # ==== Options (options)
  # :key<String>:: The complete or partial key that will be computed.
  # :action<String>:: The action name that will be used to compute the key
  # :controller<String>:: The controller name that will be part of the key
  # :params<Array[String]>::
  #   The params will be joined together (with '/') and added to the key
  # :match<Boolean, String>::
  #   true, it will try to match multiple cache entries
  #   string, shortcut for {:key => "mykey", :match => true}
  #
  # ==== Examples
  #   expire(:key => "root_key", :params => [session[:me], params[:id]])
  #   expire(:match => "root_key")
  #   expire_action(:action => 'list')
  #   expire_page(:action => 'show', :controller => 'news')
  #
  # ==== Returns
  # The result of the given block
  #
  def expire_key_for(options, controller, controller_based = false)
    key = ""
    if options.is_a? Hash
      case
      when key = options[:key]
      when action = options[:action]
        controller = options[:controller] || controller
        key = "/#{controller}/#{action}"
      when match = options[:match]
        key = match
      end
      if _params = options[:params]
        key += "/" + _params.join("/")
      end
      yield key, !options[:match].nil?
    else
      yield controller_based ? "/#{controller}/#{options}" : options, false
    end
  end

  # Compute a cache key based on the given parameters
  # Only used by the #cached_page?, #cached_action?, #cached?, #cache,
  # #cache_get and #cache_set methods
  #
  # ==== Parameters
  # options<String, Hash>:: The key or the Hash that will be used to build the key
  # controller<String>:: The name of the controller
  # controller_based<Boolean>:: only used by action and page caching
  #
  # ==== Options (options)
  # :key<String>:: The complete or partial key that will be computed.
  # :action<String>:: The action name that will be used to compute the key
  # :controller<String>:: The controller name that will be part of the key
  # :params<Array[String]>::
  #   The params will be joined together (with '/') and added to the key
  #
  # ==== Examples
  #   cache_set("my_key", @data)
  #   cache_get(:key => "root_key", :params => [session[:me], params[:id]])
  #
  # ==== Returns
  # The computed key
  def key_for(options, controller, controller_based = false)
    key = ""
    if options.is_a? Hash
      case
      when key = options[:key]
      when action = options[:action]
        controller = options[:controller] || controller
        key = "/#{controller}/#{action}"
      end
      if _params = options[:params]
        key += "/" + _params.join("/")
      end
    else
      key = controller_based ? "/#{controller}/#{options}" : options
    end
    key
  end

  module ControllerInstanceMethods
    # Mixed in Merb::Controller and provides expire_all for action and fragment caching.
    def expire_all
      Merb::Controller._cache.store.expire_all
    end
  end
end

module Merb #:nodoc:
  class Controller #:nodoc:
    cattr_reader :_cache
    @@_cache = Merb::Cache.new
    # extends Merb::Controller with new instance methods
    include Merb::Cache::ControllerInstanceMethods
    class << self #:nodoc:
      # extends Merb::Controller with new class methods
      include Merb::Cache::ControllerClassMethods
    end
  end
end

Merb::BootLoader.after_app_loads do
  # the cache starts after the application is loaded
  Merb::Controller._cache.start
end
