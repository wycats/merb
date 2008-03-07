module Merb::Cache::ControllerInstanceMethods
  # Mixed in Merb::Controller. Provides methods related to fragment caching

  # Checks whether a cache entry exists
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #key_for
  #
  # ==== Returns
  # true if the cache entry exists, false otherwise
  #
  # ==== Example
  #   cached_action?("my_key")
  def cached?(options)
    key = Merb::Controller._cache.key_for(options, controller_name)
    Merb::Controller._cache.store.cached?(key)
  end

  # ==== Example
  #   In your view:
  #   <%- cache("my_key") do -%>
  #     <%= partial :test, :collection => @test %>
  #   <%- end -%>
  def cache(options, from_now = nil, &block)
    key = Merb::Controller._cache.key_for(options, controller_name)
    Merb::Controller._cache.store.cache(self, key, from_now, &block)
  end

  # Fetch data from cache
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #key_for
  #
  # ==== Returns
  # data<Object,NilClass>::
  #   nil is returned if the cache entry is not found
  #
  # ==== Example
  #   if cache_data = cache_get("my_key")
  #     @var1, @var2 = *cache_data
  #   else
  #     @var1 = MyModel.big_query1
  #     @var2 = MyModel.big_query2
  #     cache_set("my_key", nil, [@var1, @var2])
  #   end
  def cache_get(options)
    key = Merb::Controller._cache.key_for(options, controller_name)
    Merb::Controller._cache.store.cache_get(key)
  end

  # Store data to cache
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #key_for
  # object<Object>:: The object(s) to put in cache
  # from_now<~minutes>::
  #   The number of minutes (from now) the cache should persist
  #
  # ==== Returns
  # data<Object,NilClass>::
  #   nil is returned if the cache entry is not found
  #
  # ==== Example
  #   if cache_data = cache_get("my_key")
  #     @var1, @var2 = *cache_data
  #   else
  #     @var1 = MyModel.big_query1
  #     @var2 = MyModel.big_query2
  #     cache_set("my_key", nil, [@var1, @var2])
  #   end
  def cache_set(options, object, from_now = nil)
    key = Merb::Controller._cache.key_for(options, controller_name)
    Merb::Controller._cache.store.cache_set(key, object, from_now)
  end

  # Expires the entry identified by the key computed after the parameters
  #
  # ==== Parameter
  # options<String,Hash>:: The options that will be passed to #key_for
  #
  # ==== Examples
  #   expire("my_key")
  #   expire(:key => "my_", :match => true)
  #   expire(:key => "my_key", :params => [session[:me], params[:ref]])
  def expire(options)
    Merb::Controller._cache.expire_key_for(options, controller_name) do |key, match|
      if match
        Merb::Controller._cache.store.expire_match(key)
      else
        Merb::Controller._cache.store.expire(key)
      end
    end
    true
  end
end
