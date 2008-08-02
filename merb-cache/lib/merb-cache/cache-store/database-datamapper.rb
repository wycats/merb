module Merb::Cache::DatabaseStore::DataMapper
  # Module that provides DataMapper support for the database backend

  # The cache model
  class CacheModel
    include DataMapper::Resource
    storage_names[:default] = Merb::Controller._cache.config[:table_name]
    property  :ckey, String, :length => 255, :lazy => false, :key => true
    property  :data, Text, :lazy => false
    property  :expire, DateTime, :default => nil

    # Fetch data from the database using the specified key
    # The entry is deleted if it has expired
    #
    # ==== Parameter
    # key<Sting>:: The key identifying the cache entry
    #
    # ==== Returns
    # data<String, NilClass>::
    #   nil is returned whether the entry expired or was not found
    def self.cache_get(key)
      if entry = self.get(key)
        return entry.data if entry.expire.nil? || DateTime.now < entry.expire
        entry.destroy
      end
      nil
    end

    # Store data to the database using the specified key
    #
    # ==== Parameters
    # key<Sting>:: The key identifying the cache entry
    # data<String>:: The data to be put in cache
    # expire<~minutes>::
    #   The number of minutes (from now) the cache should persist
    # get<Boolean>::
    #   used internally to behave like this:
    #   - when set to true, perform update_or_create on the cache entry
    #   - when set to false, force creation of the cache entry
    def self.cache_set(key, data, expire = nil, get = true)
      attributes = {:ckey => key, :data => data,
        :expire => expire }
      if get
        entry = self.get(key)
        entry.nil? ? self.create(attributes) : entry.update_attributes(attributes)
      else
        self.create(attributes)
      end
      true
    end

    # Expire the cache entry identified by the given key
    #
    # ==== Parameter
    # key<Sting>:: The key identifying the cache entry
    def self.expire(key)
      entry = self.get(key)
      entry.destroy unless entry.nil?
    end

    # Expire the cache entries matching the given key
    #
    # ==== Parameter
    # key<Sting>:: The key matching the cache entries
    def self.expire_match(key)
      self.all(:ckey.like => "#{key}%").destroy!
    end

    # Expire all the cache entries
    def self.expire_all
      self.all.destroy!
    end

    # Perform auto-migration in case the table is unknown in the database
    def self.check_table
      self.auto_upgrade!
    end
  end
end
