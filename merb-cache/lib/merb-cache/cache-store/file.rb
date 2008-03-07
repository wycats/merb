class Merb::Cache::Store
  # Provides the file cache store for merb-cache

  def initialize
    @config = Merb::Controller._cache.config
    @config[:cache_directory] ||= Merb.root_path("tmp/cache")
#    @config[:cache_action_directory] ||= Merb.dir_for(:public) / "cache"
    prepare
  end

  class NotAccessible < Exception #:nodoc:
    def initialize(message)
      super("Cache directories are not readable/writeable (#{message})")
    end
  end

  # This method is there to ensure minimal requirements are met
  # (directories are accessible, table exists, connected to server, ...)
  def prepare
    unless File.readable?(@config[:cache_directory]) &&
      File.writable?(@config[:cache_directory])
      raise NotAccessible, @config[:cache_directory]
    end
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
    cache_file = @config[:cache_directory] / "#{key}.cache"
    _data = _expire = nil
    if File.file?(cache_file)
      _data, _expire = Marshal.load(cache_read(cache_file))
      return true if _expire.nil? || Time.now < _expire
      FileUtils.rm_f(cache_file)
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

  # Store data to the file using the specified key
  #
  # ==== Parameters
  # key<Sting>:: The key identifying the cache entry
  # data<String>:: The data to be put in cache
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  def cache_set(key, data, from_now = nil)
    cache_file = @config[:cache_directory] / "#{key}.cache"
    cache_directory = File.dirname(cache_file)
    FileUtils.mkdir_p(cache_directory)
    _expire = from_now ? from_now.minutes.from_now : nil
    cache_write(cache_file, Marshal.dump([data, _expire]))
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
    cache_file = @config[:cache_directory] / "#{key}.cache"
    if File.file?(cache_file)
      _data, _expire = Marshal.load(cache_read(cache_file))
      return _data if _expire.nil? || Time.now < _expire
      FileUtils.rm_f(cache_file)
    end
    nil
  end

  # Expire the cache entry identified by the given key
  #
  # ==== Parameter
  # key<Sting>:: The key identifying the cache entry
  def expire(key)
    FileUtils.rm_f(@config[:cache_directory] / "#{key}.cache")
    true
  end

  # Expire the cache entries matching the given key
  #
  # ==== Parameter
  # key<Sting>:: The key matching the cache entries
  def expire_match(key)
    #files = Dir.glob(@config[:cache_directory] / "#{key}*.cache")
    files = Dir.glob(@config[:cache_directory] / "#{key}*")
    FileUtils.rm_rf(files)
    true
  end

  # Expire all the cache entries
  def expire_all
    FileUtils.rm_rf(Dir.glob("#{@config[:cache_directory]}/*"))
    true
  end

  # Gives info on the current cache store
  #
  # ==== Returns
  #   The type of the current cache store
  def cache_store_type
    "file"
  end

  private

  # Read data from the file using exclusive lock
  #
  # ==== Parameters
  # cache_file<String>:: The full path to the file
  #
  # ==== Returns
  # _data<String>:: The data read from the file
  def cache_read(cache_file)
    _data = nil
    File.open(cache_file, "r") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      _data = cache_data.read
      cache_data.flock(File::LOCK_UN)
    end
    _data
  end

  # Write data to the file using exclusive lock
  #
  # ==== Parameters
  # cache_file<String>:: The full path to the file
  # data<String>:: The data to be put in cache
  def cache_write(cache_file, data)
    File.open(cache_file, "w+") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      cache_data.write(data)
      cache_data.flock(File::LOCK_UN)
    end
    true
  end
end
