class Merb::Cache
  cattr_accessor :cached_actions
  self.cached_actions = {}
end

module Merb::Cache::ControllerClassMethods
  def cache_action(action, from_now = nil)
    cache_actions([action, from_now])
  end

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
  def cached_action?(o)
    key = Merb::Controller._cache.key_for(o, controller_name, true)
    Merb::Controller._cache.store.cached?(key)
  end

  def expire_action(o)
    Merb::Controller._cache.expire_key_for(o, controller_name, true) do |key, match|
      if match
        Merb::Controller._cache.store.expire_match(key)
      else
        Merb::Controller._cache.store.expire(key)
      end
    end
    true
  end

  private

  def _cache_action(data = nil)
    controller = controller_name
    action = action_name.to_sym
    actions = Merb::Controller._cache.cached_actions[controller]
    return unless actions && actions.key?(action)
    path = request.path
    path.chop! if path[-1] == "/"
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

  def cache_action_before
    _cache_action
  end
  def cache_action_after
    _cache_action(body) if @capture_action
  end
end
