class Merb::Cache::DatabaseStore
  # Provides the database cache store for merb-cache

  def initialize
    @config = Merb::Controller._cache.config
    prepare
  end

  class OrmNotFound < Exception #
    def initialize
      super("No valid ORM found (did you specify use_orm in init.rb?)")
    end
  end

  # Requires the ORM at startup, raising an OrmNotFound exception if
  # the backend is not found
  Merb::Controller._cache.config[:table_name] ||= "merb_cache"
  if defined?(Merb::Orms::ActiveRecord)
    require "merb-cache/cache-store/database-activerecord.rb"
    include Merb::Cache::DatabaseStore::ActiveRecord
  elsif defined?(Merb::Orms::DataMapper)
    require "merb-cache/cache-store/database-datamapper.rb"
    include Merb::Cache::DatabaseStore::DataMapper
  elsif defined?(Merb::Orms::Sequel)
    require "merb-cache/cache-store/database-sequel.rb"
    include Merb::Cache::DatabaseStore::Sequel
  else
    raise OrmNotFound
  end

  # This method is there to ensure minimal requirements are met
  # (file permissions, table exists, connected to server, ...)
  def prepare
    CacheModel.check_table
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
    not CacheModel.cache_get(key).nil?
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
    _data = CacheModel.cache_get(key)
    if _data.nil?
      _expire = from_now ? from_now.minutes.from_now : nil
      _data = _controller.send(:capture, &block)
      CacheModel.cache_set(key, Marshal.dump(_data), _expire, false)
    else
      _data = Marshal.load(_data)
    end
    _controller.send(:concat, _data, block.binding)
    true
  end

  # Store data to the database using the specified key
  #
  # ==== Parameters
  # key<Sting>:: The key identifying the cache entry
  # data<String>:: The data to be put in cache
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  def cache_set(key, data, from_now = nil)
    _expire = from_now ? from_now.minutes.from_now : nil
    CacheModel.cache_set(key, Marshal.dump(data), _expire)
    Merb.logger.info("cache: set (#{key})")
    true
  end

  # Fetch data from the database using the specified key
  # The entry is deleted if it has expired
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  #
  # ==== Returns
  # data<String, NilClass>::
  #   nil is returned whether the entry expired or was not found
  def cache_get(key)
    data = CacheModel.cache_get(key)
    Merb.logger.info("cache: #{data.nil? ? "miss" : "hit"} (#{key})")
    data.nil? ? nil : Marshal.load(data)
  end

  # Expire the cache entry identified by the given key
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  def expire(key)
    CacheModel.expire(key)
    Merb.logger.info("cache: expired (#{key})")
    true
  end

  # Expire the cache entries matching the given key
  #
  # ==== Parameter
  # key<Sting>:: The key matching the cache entries
  def expire_match(key)
    CacheModel.expire_match(key)
    Merb.logger.info("cache: expired matching (#{key})")
    true
  end

  # Expire all the cache entries
  def expire_all
    CacheModel.expire_all
    Merb.logger.info("cache: expired all")
    true
  end

  # Gives info on the current cache store
  #
  # ==== Returns
  #   The type of the current cache store
  def cache_store_type
    "database"
  end
end
