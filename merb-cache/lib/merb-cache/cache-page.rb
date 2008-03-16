class Merb::Cache
  cattr_accessor :cached_pages
  self.cached_pages = {}
end

module Merb::Cache::ControllerClassMethods
  # Mixed in Merb::Controller. Provides class methods related to page caching
  # Page caching is mostly action caching with file backend using its own output directory of .html files

  # Register the action for page caching
  #
  # ==== Parameters
  # action<Symbol>:: The name of the action to register
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  #
  # ==== Examples
  #   cache_page :mostly_static
  #   cache_page :barely_dynamic, 10
  def cache_page(action, from_now = nil)
    cache_pages([action, from_now])
  end

  # Register actions for page caching (before and after filters)
  #
  # ==== Parameter
  # pages<Symbol,Array[Symbol,~minutes]>:: See #cache_page
  #
  # ==== Example
  #   cache_pages :mostly_static, [:barely_dynamic, 10]
  def cache_pages(*pages)
    if pages.any? && Merb::Cache.cached_pages.empty?
      before(:cache_page_before)
      after(:cache_page_after)
    end
    pages.each do |action, from_now| 
      _pages = Merb::Cache.cached_pages[controller_name] ||= {}
      _pages[action] = [from_now, 0]
    end
    true
  end
end

module Merb::Cache::ControllerInstanceMethods
  # Mixed in Merb::Controller. Provides methods related to page caching

  # Checks whether a cache entry exists
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #key_for
  #
  # ==== Returns
  # true if the cache entry exists, false otherwise
  #
  # ==== Example
  #   cached_page?(:action => 'show', :params => [params[:page]])
  def cached_page?(options)
    key = Merb::Controller._cache.key_for(options, controller_name, true)
    File.file?(Merb::Controller._cache.config[:cache_html_directory] / "#{key}.html")
  end

  # Expires the page identified by the key computed after the parameters
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #expire_key_for
  #
  # ==== Examples
  #   expire_page(:action => 'show', :controller => 'news')
  #   expire_page(:action => 'show', :match => true)
  def expire_page(options)
    config_dir = Merb::Controller._cache.config[:cache_html_directory]
    Merb::Controller._cache.expire_key_for(options, controller_name, true) do |key, match|
      if match
        files = Dir.glob(config_dir / "#{key}*")
      else
        files = config_dir / "#{key}.html"
      end
      FileUtils.rm_rf(files)
    end
    true
  end

  # Expires all the pages stored in config[:cache_html_directory]
  def expire_all_pages
    FileUtils.rm_rf(Dir.glob(Merb::Controller._cache.config[:cache_html_directory] / "*"))
  end

  private

  # Called by the before and after filters. Stores or recalls a cache entry.
  # The name used for the cache file is based on request.path
  # If the name ends with "/" then it is removed
  # If the name is "/" then it will be replaced by "index"
  #
  # ==== Parameters
  # data<String>:: the data to put in cache
  #
  # ==== Examples
  #   All the file are written to config[:cache_html_directory]
  #   If request.path is "/", the name will be "/index.html"
  #   If request.path is "/news/show/1", the name will be "/news/show/1.html"
  #   If request.path is "/news/show/", the name will be "/news/show.html"
  def _cache_page(data = nil)
    controller = controller_name
    action = action_name.to_sym
    pages = Merb::Controller._cache.cached_pages[controller]
    return unless pages && pages.key?(action)
    path = request.path.chomp("/")
    path = "index" if path.empty?
    cache_file = Merb::Controller._cache.config[:cache_html_directory] / "#{path}.html"
    if data
      cache_directory = File.dirname(cache_file)
      FileUtils.mkdir_p(cache_directory)
      _expire_in = pages[action][0]
      pages[action][1] = _expire_in.minutes.from_now unless _expire_in.nil?
      cache_write_page(cache_file, data)
      Merb.logger.info("cache: set (#{path})")
    else
      @capture_page = false
      if File.file?(cache_file)
        _data = cache_read_page(cache_file)
        _expire_in, _expire_at = pages[action]
        if _expire_in.nil? || Time.now < _expire_at
          Merb.logger.info("cache: hit (#{path})")
          throw(:halt, _data)
        end
        FileUtils.rm_f(cache_file)
      end
      @capture_page = true
    end
    true
  end

  # Read data from a file using exclusive lock
  #
  # ==== Parameters
  # cache_file<String>:: the full path to the file
  #
  # ==== Returns
  # data<String>:: the data that has been read from the file
  def cache_read_page(cache_file)
    _data = nil
    File.open(cache_file, "r") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      _data = cache_data.read
      cache_data.flock(File::LOCK_UN)
    end
    _data
  end

  # Write data to a file using exclusive lock
  #
  # ==== Parameters
  # cache_file<String>:: the full path to the file
  # data<String>:: the data that will be written to the file
  def cache_write_page(cache_file, data)
    File.open(cache_file, "w+") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      cache_data.write(data)
      cache_data.flock(File::LOCK_UN)
    end
    true
  end

  # before filter
  def cache_page_before
    # recalls a cached entry or set @capture_page to true in order
    # to grab the response in the after filter
    _cache_page
  end

  # after filter
  def cache_page_after
    # takes the body of the response
    # put it in cache only if the cache entry expired or doesn't exist
    _cache_page(body) if @capture_page
  end
end
