module Merb::Cache::DatabaseStore::DataMapper
  # Module that provides DataMapper support for the database backend

  # The cache model
  class CacheModel < DataMapper::Base
    set_table_name Merb::Controller._cache.config[:table_name]
    property  :ckey, :string, :length => 255, :lazy => false, :key => true
    property  :data, :text, :lazy => false
    property  :expire, :datetime, :default => nil

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
      if entry = self.first(key)
        return entry.data if entry.expire.nil? || DateTime.now < entry.expire
        entry.destroy!
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
        :expire => expire.nil? ? nil : expire.to_s_db }
      if get
        entry = self.first(key)
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
      entry = self.first(key)
      entry.destroy! unless entry.nil?
    end

    # Expire the cache entries matching the given key
    #
    # ==== Parameter
    # key<Sting>:: The key matching the cache entries
    def self.expire_match(key)
      #FIXME
      database.execute("DELETE FROM #{self.table.name} WHERE ckey LIKE '#{key}%'")
    end

    # Expire all the cache entries
    def self.expire_all
      self.truncate!
    end

    # Perform auto-migration in case the table is unknown in the database
    def self.check_table
      self.auto_migrate! unless self.table.exists?
    end
  end
end
