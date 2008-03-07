module Merb::Cache::Store::ActiveRecord
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

  class CacheModel < ActiveRecord::Base
    set_table_name Merb::Controller._cache.config[:table_name]
    def self.cache_get(key)
      if entry = self.find(:first, :conditions => ["ckey=?", key])
        return entry.data if entry.expire.nil? || Time.now < entry.expire
        self.expire(key)
      end
      nil
    end

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

    def self.expire(key)
      self.delete_all(["ckey=?", key])
    end

    def self.expire_match(key)
      self.delete_all(["ckey like ?", key + "%"])
    end

    def self.expire_all
      self.delete_all
    end

    def self.check_table
      CacheMigration.up unless self.table_exists?
    end
  end
end
