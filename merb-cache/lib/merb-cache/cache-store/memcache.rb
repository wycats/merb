class Merb::Cache::Store
  def initialize
    @config = Merb::Controller._cache.config
    prepare
  end

  class NotReady < Exception
    def initialize
      super("Memcache server is not ready")
    end
  end
  class NotDefined < Exception
    def initialize
      super("Memcache is not defined (require it in init.rb)")
    end
  end

  def prepare
    namespace = @config[:namespace] || 'merb-cache'
    host = @config[:host] || '127.0.0.1:11211'
    @memcache = MemCache.new(host, {:namespace => namespace})
    raise NotReady unless @memcache.active?
    true
  rescue NameError
    raise NotDefined
  end

  def cached?(key)
    not @memcache.get(key).nil?
  end

  def cache(_controller, key, from_now = nil, &block)
    _data = @memcache.get(key)
    if _data.nil?
      _expire = from_now ? from_now.minutes.from_now.to_i : 0
      _data = _controller.capture(&block)
      @memcache.set(key, _data, _expire)
    end
    _controller.concat(_data, block.binding)
    true
  end

  def cache_set(key, data, from_now = nil)
    _expire = from_now ? from_now.minutes.from_now.to_i : 0
    @memcache.set(key, data, _expire)
    true
  end

  def cache_get(key)
    @memcache.get(key)
  end

  def expire(key)
    @memcache.delete(key)
    true
  end

  def expire_match(key)
    Merb.logger.info("MERB-CACHE (cache_store: 'memcache'): expire_match not supported")
    true
  end

  def expire_all
    @memcache.flush_all
    true
  end

  def cache_store_type
    "memcache"
  end
end
