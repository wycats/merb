class Merb::Cache::Store
  # Provides the memcache cache store for merb-cache

  def initialize
    @config = Merb::Controller._cache.config
    prepare
  end

  class NotReady < Exception #:nodoc:
    def initialize
      super("Memcache server is not ready")
    end
  end

  class NotDefined < Exception #:nodoc:
    def initialize
      super("Memcache is not defined (require it in init.rb)")
    end
  end

  # This method is there to ensure minimal requirements are met
  # (directories are accessible, table exists, connected to server, ...)
  def prepare
    namespace = @config[:namespace] || 'merb-cache'
    host = @config[:host] || '127.0.0.1:11211'
    @memcache = MemCache.new(host, {:namespace => namespace})
    @tracking_key = "_#{namespace}_keys" unless @config[:no_tracking]
    raise NotReady unless @memcache.active?
    true
  rescue NameError
    raise NotDefined
  end

  # Checks whether a cache entry exists
  #
  # ==== Parameter
  # key<String>:: The key identifying the cache entry
  #
  # ==== Returns
  # true if the cache entry exists, false otherwise
  def cached?(key)
    not @memcache.get(key).nil?
  end

  # Capture or restore the data in cache.
  # If the cache entry expired or does not exist, the data are taken
  # from the execution of the block, marshalled and stored in cache.
  # Otherwise, the data are loaded from the cache and returned unmarshalled
  #
  # ==== Parameters
  # _controller<Merb::Controller>:: The instance of the current controller
  # key<String>:: The key identifying the cache entry
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  # &block:: The template to be used or not
  #
  # ==== Additional information
  # When fetching data (the cache entry exists and has not expired)
  # The data are loaded from the cache and returned unmarshalled.
  # Otherwise:
  # The controller is used to capture the rendered template (from the block).
  # It uses the capture_#{engine} and concat_#{engine} methods to do so.
  # The captured data are then marshalled and stored.
  def cache(_controller, key, from_now = nil, &block)
    _data = @memcache.get(key)
    if _data.nil?
      _expire = from_now ? from_now.minutes.from_now.to_i : 0
      _data = _controller.send(:capture, &block)
      @memcache.set(key, _data, _expire)
    end
    _controller.send(:concat, _data, block.binding)
    true
  end

  # Store data to memcache using the specified key
  #
  # ==== Parameters
  # key<Sting>:: The key identifying the cache entry
  # data<String>:: The data to be put in cache
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  def cache_set(key, data, from_now = nil)
    _expire = from_now ? from_now.minutes.from_now.to_i : 0
    @memcache.set(key, data, _expire)
    cache_start_tracking(key)
    Merb.logger.info("cache: set (#{key})")
    true
  end

  # Fetch data from memcache using the specified key
  # The entry is deleted if it has expired
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  #
  # ==== Returns
  # data<String, NilClass>::
  #   nil is returned whether the entry expired or was not found
  def cache_get(key)
    data = @memcache.get(key)
    Merb.logger.info("cache: #{data.nil? ? "miss" : "hit"} (#{key})")
    data
  end

  # Expire the cache entry identified by the given key
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  def expire(key)
    @memcache.delete(key)
    cache_stop_tracking(key)
    Merb.logger.info("cache: expired (#{key})")
    true
  end

  # Expire the cache entries matching the given key
  #
  # ==== Parameter
  # key<Sting>:: The key matching the cache entries
  #
  # ==== Additional info
  #   In memcache this requires to keep track of all keys (on by default).
  #   If you don't need this, set :no_tracking => true in the config.
  def expire_match(key)
    if @tracking_key
      for _key in get_tracked_keys
        expire(_key) if /#{key}/ =~ _key
      end
    else
      Merb.logger.info("cache: expire_match is not supported with memcache (set :no_tracking => false in your config")
    end
    true
  end

  # Expire all the cache entries
  def expire_all
    @memcache.flush_all
    stop_tracking_keys
    Merb.logger.info("cache: expired all")
    true
  end

  # Gives info on the current cache store
  #
  # ==== Returns
  #   The type of the current cache store
  def cache_store_type
    "memcache"
  end

  private

  # Store the tracked keys in memcache (used by expire_match)
  #
  # ==== Parameter
  # keys<Array[String]>:: The keys to keep track of
  def set_tracked_keys(keys)
    @memcache.set(@tracking_key, keys)
  end

  # Retrieve tracked keys from memcache
  #
  # ==== Returns
  # keys<Array[String]>:: The tracked keys
  def get_tracked_keys
    @memcache.get(@tracking_key) || []
  end

  # Remove all tracked keys
  def stop_tracking_keys
    @memcache.delete(@tracking_key) if @tracking_key
  end

  # Add a key in the array of tracked keys (used by expire_match)
  #
  # ==== Parameter
  # key<String>:: the key to add
  def cache_start_tracking(key)
    return unless @tracking_key
    keys = get_tracked_keys
    keys.push(key)
    set_tracked_keys(keys)
  end

  # Remove a key from the array of tracked keys (used by expire_match)
  #
  # ==== Parameter
  # key<String>:: the key to remove
  def cache_stop_tracking(key)
    return unless @tracking_key
    keys = get_tracked_keys
    keys.delete(key)
    set_tracked_keys(keys)
  end
end
