class Merb::Cache::Store
  def initialize
    @config = Merb::Controller._cache.config
    prepare
  end

  class OrmNotFound < Exception
    def initialize
      super("No valid ORM found (did you specify use_orm in init.rb?)")
    end
  end

  Merb::Controller._cache.config[:table_name] ||= "merb_cache"
  if defined?(Merb::Orms::ActiveRecord)
    require "merb-cache/cache-store/database-activerecord.rb"
    include Merb::Cache::Store::ActiveRecord
  elsif defined?(Merb::Orms::DataMapper)
    require "merb-cache/cache-store/database-datamapper.rb"
    include Merb::Cache::Store::DataMapper
  elsif defined?(Merb::Orms::Sequel)
    require "merb-cache/cache-store/database-sequel.rb"
    include Merb::Cache::Store::Sequel
  else
    raise OrmNotFound
  end

  def prepare
    CacheModel.check_table
    true
  end

  def cached?(key)
    not CacheModel.cache_get(key).nil?
  end

  def cache(_controller, key, from_now = nil, &block)
    _data = CacheModel.cache_get(key)
    if _data.nil?
      _expire = from_now ? from_now.minutes.from_now : nil
      _data = _controller.capture(&block)
      CacheModel.cache_set(key, Marshal.dump(_data), _expire, false)
    else
      _data = Marshal.load(_data)
    end
    _controller.concat(_data, block.binding)
    true
  end

  def cache_set(key, data, from_now = nil)
    _expire = from_now ? from_now.minutes.from_now : nil
    CacheModel.cache_set(key, Marshal.dump(data), _expire)
    true
  end

  def cache_get(key)
    data = CacheModel.cache_get(key)
    data.nil? ? nil : Marshal.load(data)
  end

  def expire(key)
    CacheModel.expire(key)
    true
  end

  def expire_match(key)
    CacheModel.expire_match(key)
    true
  end

  def expire_all
    CacheModel.expire_all
    true
  end

  def cache_store_type
    "database"
  end
end
