module Merb::Cache::DatabaseStore::ActiveRecord
  # Module that provides ActiveRecord support for the database backend

  # The cache model migration
  class CacheMigration < ActiveRecord::Migration
    def self.up
      create_table (Merb::Controller._cache.config[:table_name]), :primary_key => :ckey do |t|
        t.column    :ckey, :string
        t.column    :data, :text
        t.datetime  :expire, :default => nil
      end
    end

    def self.down
      drop_table Merb::Controller._cache.config[:table_name]
    end
  end

  # The cache model
  class CacheModel < ActiveRecord::Base
    set_table_name Merb::Controller._cache.config[:table_name]

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
      if entry = self.find(:first, :conditions => ["ckey=?", key])
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
        entry = self.find(:first, :conditions => ["ckey=?",key])
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
      self.delete_all(["ckey=?", key])
    end

    # Expire the cache entries matching the given key
    #
    # ==== Parameter
    # key<Sting>:: The key matching the cache entries
    def self.expire_match(key)
      self.delete_all(["ckey like ?", key + "%"])
    end

    # Expire all the cache entries
    def self.expire_all
      self.delete_all
    end

    # Perform auto-migration in case the table is unknown in the database
    def self.check_table
      CacheMigration.up unless self.table_exists?
    end
  end
end
