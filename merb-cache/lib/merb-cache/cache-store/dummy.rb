class Merb::Cache::DummyStore
  # Provides dummy cache store for merb-cache

  def initialize
    @config = Merb::Controller._cache.config
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
    _data = _controller.send(:capture, &block)
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
    nil
  end

  # Expire the cache entry identified by the given key
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  def expire(key)
    true
  end

  # Expire the cache entries matching the given key
  #
  # ==== Parameter
  # key<Sting>:: The key matching the cache entries
  #
  # ==== Warning !
  #   This does not work in memcache.
  def expire_match(key)
    true
  end

  # Expire all the cache entries
  def expire_all
    true
  end

  # Gives info on the current cache store
  #
  # ==== Returns
  #   The type of the current cache store
  def cache_store_type
    "dummy"
  end
end
