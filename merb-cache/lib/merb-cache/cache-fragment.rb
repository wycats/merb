module Merb::Cache::ControllerInstanceMethods
  def cached?(o)
    key = Merb::Controller._cache.key_for(o, controller_name)
    Merb::Controller._cache.store.cached?(key)
  end

  # In your view:
  # <%- cache("my_key") do -%>
  #   <%= partial :test, :collection => @test %>
  # <%- end -%>
  def cache(o, from_now = nil, &block)
    key = Merb::Controller._cache.key_for(o, controller_name)
    Merb::Controller._cache.store.cache(self, key, from_now, &block)
  end

  # # In your controller:
  # if cache_data = cache_get("my_key")
  #   @var1, @var2 = *cache_data
  # else
  #   @var1 = MyModel.big_query1
  #   @var2 = MyModel.big_query2
  #   cache_set("my_key", nil, [@var1, @var2])
  # end
  def cache_get(o)
    key = Merb::Controller._cache.key_for(o, controller_name)
    Merb::Controller._cache.store.cache_get(key)
  end

  def cache_set(o, object, from_now = nil)
    key = Merb::Controller._cache.key_for(o, controller_name)
    Merb::Controller._cache.store.cache_set(key, object, from_now)
  end

  def expire(o)
    Merb::Controller._cache.expire_key_for(o, controller_name) do |key, match|
      if match
        Merb::Controller._cache.store.expire_match(key)
      else
        Merb::Controller._cache.store.expire(key)
      end
    end
    true
  end
end
