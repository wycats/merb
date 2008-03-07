class Merb::Cache::Store
  def initialize
    @config = Merb::Controller._cache.config
    @cache = {}
    @mutex = Mutex.new
    prepare
  end

  def prepare
    true
  end

  def cached?(key)
    if @cache.key?(key)
      _data, _expire = *cache_read(key)
      return true if _expire.nil? || Time.now < _expire
      expire(key)
    end
    false
  end

  def cache(_controller, key, from_now = nil, &block)
    if @cache.key?(key)
      _data, _expire = *cache_read(key)
      _cache_hit = _expire.nil? || Time.now < _expire
    end
    unless _cache_hit
      _expire = from_now ? from_now.minutes.from_now : nil
      _data = _controller.capture(&block)
      cache_write(key, [_data, _expire])
    end
    _controller.concat(_data, block.binding)
    true
  end

  def cache_set(key, data, from_now = nil)
    _expire = from_now ? from_now.minutes.from_now : nil
    cache_write(key, [data, _expire])
    true
  end

  def cache_get(key)
    if @cache.key?(key)
      _data, _expire = *cache_read(key)
      return _data if _expire.nil? || Time.now < _expire
    end
    nil
  end

  def expire(key)
    @mutex.synchronize do
      @cache.delete(key)
    end
    true
  end

  def expire_match(key)
    @mutex.synchronize do
      @cache.delete_if do |k,v| k.match(/#{key}/) end
    end
    true
  end

  def expire_all
    @mutex.synchronize do
      @cache.clear
    end
    true
  end

  def cache_store_type
    "memory"
  end

  private

  def cache_read(key)
    @mutex.synchronize do
      @cache[key]
    end
  end

  def cache_write(key, data)
    @mutex.synchronize do
      @cache[key] = data
    end
  end
end
