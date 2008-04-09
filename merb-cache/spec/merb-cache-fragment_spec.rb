# TODO
# more specs for fragment caching:
# cache_get, cache_set, cached?, cache, expire

describe "merb-cache-fragment" do

  it "should render index" do
    c = dispatch_to(CacheController, :index)
    c.body.should == "test index"
  end

  it "should cache the fragment (erb capture/concat)" do
    c = dispatch_to(CacheController, :action1)
    NOW = c.body.strip
    c.cache_get("key1").strip.should == NOW
  end

  it "should cache the fragment (haml capture/concat)" do
    c = dispatch_to(CacheController, :action2)
    now = c.body.strip
    c.cache_get("key11").strip.should == now
    sleep 1
    c = dispatch_to(CacheController, :action2)
    c.cache_get("key11").strip.should == now
    c.expire("key11")
    c.cache_get("key11").should be_nil
  end

  it "should use the fragment" do
    sleep 1
    c = dispatch_to(CacheController, :action1)
    c.body.strip.should == NOW
  end

  it "should expire the fragment" do
    CACHE.expire("key1")
    CACHE.cache_get("key1").should be_nil
  end

  it "should refresh the template" do
    c = dispatch_to(CacheController, :action1)
    c.body.strip.should_not == NOW
  end

  it "should return nil for unknown keys" do
    CACHE.cache_get("unknown_key").should be_nil
  end

  it "should expire matching keys" do
    CACHE.cache_set("test1", "test1")
    CACHE.cache_get("test1").should == "test1"
    CACHE.cache_set("test2", "test2")
    CACHE.cache_get("test2").should == "test2"
    CACHE.cache_set("test3", "test3")
    CACHE.cache_get("test3").should == "test3"
    CACHE.expire(:match => "test")
    CACHE.cache_get("test1").should be_nil
    CACHE.cache_get("test2").should be_nil
    CACHE.cache_get("test3").should be_nil
  end

  it "should expire entry after 3 seconds" do
    CACHE.cache_set("timed_key", "vanish in 3 seconds", 0.05)
    CACHE.cache_get("timed_key").should == "vanish in 3 seconds"
    sleep 3.5
    CACHE.cache_get("timed_key").should be_nil
  end

  it "should expire in many ways" do
    CACHE.cache_set("test1", "test1")
    CACHE.expire("test1")
    CACHE.cache_get("test1").should be_nil

    CACHE.cache_set("test2/id1", "test2")
    CACHE.expire(:key => "test2", :params => %w(id1))
    CACHE.cache_get("test2/id1").should be_nil

    CACHE.cache_set("test3", "test3")
    CACHE.expire(:key => "test3")
    CACHE.cache_get("test3").should be_nil

    CACHE.cache_set("test4/id1", "test4")
    CACHE.expire(:key => "test4", :params => %w(id1), :match => true)
    CACHE.cache_get("test4/id1/id2").should be_nil
  end

  it "should expire all keys" do
    CACHE.expire_all
    CACHE.cache_get("key1").should be_nil
  end

  it "should cache/restore ruby objects" do
    now = Time.now
    data = {:key1 => "key1", :key2 => "key2", :now => Time.now }
    CACHE.cache_set("key1", data)
    _data = CACHE.cache_get("key1")
    data.should == _data
  end

end
