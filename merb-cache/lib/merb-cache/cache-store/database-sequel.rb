module Merb::Cache::DatabaseStore::Sequel
  # Module that provides Sequel support for the database backend

  # The cache model
  class CacheModel < Sequel::Model(Merb::Controller._cache.config[:table_name].to_sym)
    set_schema do
      primary_key :id
      varchar     :ckey, :index => true
      varchar     :data
      timestamp   :expire, :default => nil
    end

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
      if entry = self.filter(:ckey => key).single_record(:limit => 1)
        return entry.data if entry.expire.nil? || Time.now < entry.expire
        self.expire(key)
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
    #   used internally to behave like this
    #   - when set to true, perform update_or_create on the cache entry
    #   - when set to false, force creation of the cache entry
    def self.cache_set(key, data, expire = nil, get = true)
      attributes = {:ckey => key, :data => data, :expire => expire }
      if get
        entry = self.filter(:ckey => key).single_record(:limit => 1)
        entry.nil? ? self.create(attributes) : entry.set(attributes)
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
      self.filter(:ckey => key).delete
    end

    # Expire the cache entries matching the given key
    #
    # ==== Parameter
    # key<Sting>:: The key matching the cache entries
    def self.expire_match(key)
      self.filter{:ckey.like  key + "%"}.delete
    end

    # Expire all the cache entries
    def self.expire_all
      self.delete_all
    end

    # Perform auto-migration in case the table is unknown in the database
    def self.check_table
      self.create_table unless self.table_exists?
    end
  end
end
