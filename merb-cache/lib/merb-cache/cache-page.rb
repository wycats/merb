class Merb::Cache
  cattr_accessor :cached_pages
  self.cached_pages = {}
end

module Merb::Cache::ControllerClassMethods
  def cache_page(action, from_now = nil)
    cache_pages([action, from_now])
  end

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
  def cached_page?(o)
    key = Merb::Controller._cache.key_for(o, controller_name, true)
    File.file?(Merb::Controller._cache.config[:cache_html_directory] / "#{key}.html")
  end

  def expire_page(o)
    config_dir = Merb::Controller._cache.config[:cache_html_directory]
    Merb::Controller._cache.expire_key_for(o, controller_name, true) do |key, match|
      if match
        files = Dir.glob(config_dir / "#{key}*")
      else
        files = config_dir / "#{key}.html"
      end
      FileUtils.rm_rf(files)
    end
    true
  end

  def expire_all_pages
    FileUtils.rm_rf(Dir.glob(Merb::Controller._cache.config[:cache_html_directory] / "*"))
  end

  private

  def _cache_page(data = nil)
    controller = controller_name
    action = action_name.to_sym
    pages = Merb::Controller._cache.cached_pages[controller]
    return unless pages && pages.key?(action)
    path = request.path
    path.chop! if path[-1] == "/"
    path = "index" if path.empty?
    cache_file = Merb::Controller._cache.config[:cache_html_directory] / "#{path}.html"
    if data
      cache_directory = File.dirname(cache_file)
      FileUtils.mkdir_p(cache_directory)
      _expire_in = pages[action][0]
      pages[action][1] = _expire_in.minutes.from_now unless _expire_in.nil?
      cache_write_page(cache_file, data)
    else
      @capture_page = false
      if File.file?(cache_file)
        _data = cache_read_page(cache_file)
        _expire_in, _expire_at = pages[action]
        throw(:halt, _data) if _expire_in.nil? || Time.now < _expire_at
        FileUtils.rm_f(cache_file)
      end
      @capture_page = true
    end
    true
  end

  def cache_read_page(cache_file)
    _data = nil
    File.open(cache_file, "r") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      _data = cache_data.read
      cache_data.flock(File::LOCK_UN)
    end
    _data
  end

  def cache_write_page(cache_file, data)
    File.open(cache_file, "w+") do |cache_data|
      cache_data.flock(File::LOCK_EX)
      cache_data.write(data)
      cache_data.flock(File::LOCK_UN)
    end
    true
  end

  def cache_page_before
    _cache_page
  end
  def cache_page_after
    _cache_page(body) if @capture_page
  end
end
