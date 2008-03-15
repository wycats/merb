class Merb::Cache::MemoryStore
  # Provides the memory cache store for merb-cache

  def initialize
    @config = Merb::Controller._cache.config
    @cache = {}
    @mutex = Mutex.new
    prepare
  end

  # This method is there to ensure minimal requirements are met
  # (directories are accessible, table exists, connected to server, ...)
  def prepare
    true
  end

  # Checks whether a cache entry exists
  #
  # ==== Parameter
  # key<String>:: The key identifying the cache entry
  #
  # ==== Returns
  # true if the cache entry exists, false otherwise
  def cached?(key)
    if @cache.key?(key)
      _data, _expire = *cache_read(key)
      return true if _expire.nil? || Time.now < _expire
      expire(key)
    end
    false
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
    if @cache.key?(key)
      _data, _expire = *cache_read(key)
      _cache_hit = _expire.nil? || Time.now < _expire
    end
    unless _cache_hit
      _expire = from_now ? from_now.minutes.from_now : nil
      _data = _controller.send(:capture, &block)
      cache_write(key, [_data, _expire])
    end
    _controller.send(:concat, _data, block.binding)
    true
  end

  # Store data to the file using the specified key
  #
  # ==== Parameters
  # key<Sting>:: The key identifying the cache entry
  # data<String>:: The data to be put in cache
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  def cache_set(key, data, from_now = nil)
    _expire = from_now ? from_now.minutes.from_now : nil
    cache_write(key, [data, _expire])
    Merb.logger.info("cache: set (#{key})")
    true
  end

  # Fetch data from the file using the specified key
  # The entry is deleted if it has expired
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  #
  # ==== Returns
  # data<String, NilClass>::
  #   nil is returned whether the entry expired or was not found
  def cache_get(key)
    if @cache.key?(key)
      _data, _expire = *cache_read(key)
      if _expire.nil? || Time.now < _expire
        Merb.logger.info("cache: hit (#{key})")
        return _data
      end
      @mutex.synchronize do @cache.delete(key) end
    end
    Merb.logger.info("cache: miss (#{key})")
    nil
  end

  # Expire the cache entry identified by the given key
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  def expire(key)
    @mutex.synchronize do
      @cache.delete(key)
    end
    Merb.logger.info("cache: expired (#{key})")
    true
  end

  # Expire the cache entries matching the given key
  #
  # ==== Parameter
  # key<Sting>:: The key matching the cache entries
  def expire_match(key)
    @mutex.synchronize do
      @cache.delete_if do |k,v| k.match(/#{key}/) end
    end
    Merb.logger.info("cache: expired matching (#{key})")
    true
  end

  # Expire all the cache entries
  def expire_all
    @mutex.synchronize do
      @cache.clear
    end
    Merb.logger.info("cache: expired all")
    true
  end

  # Gives info on the current cache store
  #
  # ==== Returns
  #   The type of the current cache store
  def cache_store_type
    "memory"
  end

  private

  # Read data from the memory hash table using mutex
  #
  # ==== Parameters
  # cache_file<String>:: The key identifying the cache entry
  #
  # ==== Returns
  # _data<String>:: The data fetched from the cache
  def cache_read(key)
    @mutex.synchronize do
      @cache[key]
    end
  end

  # Write data to the memory hash table using mutex
  #
  # ==== Parameters
  # cache_file<String>:: The key identifying the cache entry
  # data<String>:: The data to be put in cache
  def cache_write(key, data)
    @mutex.synchronize do
      @cache[key] = data
    end
  end
end
