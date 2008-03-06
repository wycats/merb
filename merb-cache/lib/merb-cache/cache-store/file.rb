class Merb::Cache::Store
  def initialize
    @config = Merb::Controller._cache.config
    @config[:cache_directory] ||= Merb.root_path("tmp/cache")
#    @config[:cache_action_directory] ||= Merb.dir_for(:public) / "cache"
    prepare
  end

  class NotAccessible < Exception
    def initialize(message)
      super("Cache directories are not readable/writeable (#{message})")
    end
  end

  def prepare
    unless File.readable?(@config[:cache_directory]) &&
      File.writable?(@config[:cache_directory])
      raise NotAccessible, @config[:cache_directory]
    end
    true
  end

  def cached?(key)
    cache_file = @config[:cache_directory] / "#{key}.cache"
    _data = _expire = nil
    if File.file?(cache_file)
      _data, _expire = Marshal.load(cache_read(cache_file))
      return true if _expire.nil? || Time.now < _expire
      FileUtils.rm_f(cache_file)
    end
    false
  end

  def cache(_controller, key, from_now = nil, &block)
    cache_file = @config[:cache_directory] / "#{key}.cache"
    _cache_hit = _data = _expire = nil
   
    if File.file?(cache_file)
      _data, _expire = Marshal.load(cache_read(cache_file))
      _cache_hit = true if _expire.nil? || Time.now < _expire
    end
    unless _cache_hit
      cache_directory = File.dirname(cache_file)
      FileUtils.mkdir_p(cache_directory)
      _expire = from_now ? from_now.minutes.from_now : nil
      _data = _controller.capture(&block)
      cache_write(cache_file, Marshal.dump([_data, _expire]))
    end
    _controller.concat(_data, block.binding)
    true
  end

  def cache_set(key, data, from_now = nil)
    cache_file = @config[:cache_directory] / "#{key}.cache"
    cache_directory = File.dirname(cache_file)
    FileUtils.mkdir_p(cache_directory)
    _expire = from_now ? from_now.minutes.from_now : nil
    cache_write(cache_file, Marshal.dump([data, _expire]))
    true
  end

  def cache_get(key)
    cache_file = @config[:cache_directory] / "#{key}.cache"
    if File.file?(cache_file)
      _data, _expire = Marshal.load(cache_read(cache_file))
      return _data if _expire.nil? || Time.now < _expire
      FileUtils.rm_f(cache_file)
    end
    nil
  end

  def expire(key)
    FileUtils.rm_f(@config[:cache_directory] / "#{key}.cache")
    true
  end

  def expire_match(key)
    #files = Dir.glob(@config[:cache_directory] / "#{key}*.cache")
    files = Dir.glob(@config[:cache_directory] / "#{key}*")
    FileUtils.rm_rf(files)
    true
  end

  def expire_all
    FileUtils.rm_rf(Dir.glob("#{@config[:cache_directory]}/*"))
    true
  end

  def cache_store_type
    "file"
  end

  private

  def cache_read(cache_file)
    _data = nil
    File.open(cache_file, "r") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      _data = cache_data.read
      cache_data.flock(File::LOCK_UN)
    end
    _data
  end

  def cache_write(cache_file, data)
    File.open(cache_file, "w+") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      cache_data.write(data)
      cache_data.flock(File::LOCK_UN)
    end
    true
  end
end
