module Merb::Cache::Store::DataMapper
  class CacheModel < DataMapper::Base
    set_table_name Merb::Controller._cache.config[:table_name]
    property  :ckey, :string, :length => 255, :lazy => false, :key => true
    property  :data, :text, :lazy => false
    property  :expire, :datetime, :default => nil

    def self.cache_get(key)
      if entry = self.first(key)
        return entry.data if entry.expire.nil? || DateTime.now < entry.expire
        entry.destroy!
      end
      nil
    end

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

    def self.expire(key)
      entry = self.first(key)
      entry.destroy! unless entry.nil?
    end

    def self.expire_match(key)
      #FIXME
      database.execute("DELETE FROM #{self.table.name} WHERE ckey LIKE '#{key}%'")
    end

    def self.expire_all
      self.truncate!
    end

    def self.check_table
      self.auto_migrate! unless self.table.exists?
    end
  end
end
