module Merb::Cache::Store::Sequel
  class CacheModel < Sequel::Model(Merb::Controller._cache.config[:table_name].to_sym)
    set_schema do
      primary_key :id
      varchar     :ckey, :index => true
      varchar     :data
      timestamp   :expire, :default => nil
    end

    def self.cache_get(key)
      if entry = self.filter(:ckey => key).single_record(:limit => 1)
        return entry.data if entry.expire.nil? || Time.now < entry.expire
        self.expire(key)
      end
      nil
    end

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

    def self.expire(key)
      self.filter(:ckey => key).delete
    end

    def self.expire_match(key)
      self.filter{:ckey.like  key + "%"}.delete
    end

    def self.expire_all
      self.delete_all
    end

    def self.check_table
      self.create_table unless self.table_exists?
    end
  end
end
