class Merb::Cache
  cattr_accessor :cached_actions
  self.cached_actions = {}
end

module Merb::Cache::ControllerClassMethods
  # Mixed in Merb::Controller. Provides methods related to action caching

  # Register the action for action caching
  #
  # ==== Parameters
  # action<Symbol>:: The name of the action to register
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  #
  # ==== Examples
  #   cache_action :mostly_static
  #   cache_action :barely_dynamic, 10
  def cache_action(action, from_now = nil)
    cache_actions([action, from_now])
  end

  # Register actions for action caching (before and after filters)
  #
  # ==== Parameter
  # actions<Symbol,Array[Symbol,~minutes]>:: See #cache_action
  #
  # ==== Example
  #   cache_actions :mostly_static, [:barely_dynamic, 10]
  def cache_actions(*actions)
    if actions.any? && Merb::Cache.cached_actions.empty?
      before(:cache_action_before)
      after(:cache_action_after)
    end
    actions.each do |action, from_now| 
      _actions = Merb::Cache.cached_actions[controller_name] ||= {}
      _actions[action] = from_now
    end
    true
  end
end

module Merb::Cache::ControllerInstanceMethods
  # Mixed in Merb::Controller. Provides methods related to action caching

  # Checks whether a cache entry exists
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #key_for
  #
  # ==== Returns
  # true if the cache entry exists, false otherwise
  #
  # ==== Example
  #   cached_action?(:action => 'show', :params => [params[:page]])
  def cached_action?(options)
    key = Merb::Controller._cache.key_for(options, controller_name, true)
    Merb::Controller._cache.store.cached?(key)
  end

  # Expires the action identified by the key computed after the parameters
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #expire_key_for
  #
  # ==== Examples
  #   expire_action(:action => 'show', :controller => 'news')
  #   expire_action(:action => 'show', :match => true)
  def expire_action(options)
    Merb::Controller._cache.expire_key_for(options, controller_name, true) do |key, match|
      if match
        Merb::Controller._cache.store.expire_match(key)
      else
        Merb::Controller._cache.store.expire(key)
      end
    end
    true
  end

  private

  # Called by the before and after filters. Stores or recalls a cache entry.
  # The key is based on the result of request.path
  # If the key with "/" then it is removed
  # If the key is "/" then it will be replaced by "index"
  #
  # ==== Parameters
  # data<String>:: the data to put in cache using the cache store
  #
  # ==== Examples
  #   If request.path is "/", the key will be "index"
  #   If request.path is "/news/show/1", the key will be "/news/show/1"
  #   If request.path is "/news/show/", the key will be "/news/show"
  def _cache_action(data = nil)
    controller = controller_name
    action = action_name.to_sym
    actions = Merb::Controller._cache.cached_actions[controller]
    return unless actions && actions.key?(action)
    path = request.path.chomp("/")
    path = "index" if path.empty?
    if data
      from_now = Merb::Controller._cache.cached_actions[controller][action]
      Merb::Controller._cache.store.cache_set(path, data, from_now)
    else
      @capture_action = false
      _data = Merb::Controller._cache.store.cache_get(path)
      throw(:halt, _data) unless _data.nil?
      @capture_action = true
    end
    true
  end

  # before filter
  def cache_action_before
    # recalls a cached entry or set @capture_action to true in order
    # to grab the response in the after filter
    _cache_action
  end

  # after filter
  def cache_action_after
    # takes the body of the response
    # put it in cache only if the cache entry expired or doesn't exist
    _cache_action(body) if @capture_action
  end
end
