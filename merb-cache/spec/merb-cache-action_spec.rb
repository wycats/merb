describe "merb-cache-action" do

  it "should cache action (action3)" do
    c = get("/cache_controller/action3")
    c.body.strip.should == "test action3"
    c.cached?("/cache_controller/action3").should be_true
    c.cached_action?("action3").should be_true
    c.cache_get("/cache_controller/action3").should == "test action3"
  end

  it "should expire action (action3)" do
    CACHE.expire_action "action3"
    CACHE.cache_get("/cache_controller/action3").should be_nil
  end

  it "should cache action (action3) with full path" do
    c = get("/cache_controller/action3/abc/456/ghi")
    c.body.strip.should == "test action3"
    c.cached?(c.request.path).should be_true
    c.cache_get(c.request.path).should == "test action3"
  end

  it "should expire action (action3) with full path" do
    c = get("/cache_controller/action3/abc/456/ghi")
    c.expire_action(:key => c.request.path)
    c.cache_get(c.request.path).should be_nil
  end

  it "should expire action (action4) after 3 seconds" do
    c = get("/cache_controller/action4")
    c.body.strip.should == "test action4"
    c.cached?("/cache_controller/action4").should be_true
    c.cache_get("/cache_controller/action4").should == "test action4"
    sleep 4
    c.cache_get("/cache_controller/action4").should be_nil
    c.cached_action?(:action => "action4").should be_false
  end

  it "should cache action with full path (action4) and expire in 3 seconds" do
    CACHE.expire_action :match => true, :action => "action4"
    CACHE.cached_action?(:action => "action4", :params => %w(path to nowhere)).should be_false
    c = get("/cache_controller/action4/path/to/nowhere/")
    c.cached_action?(:action => "action4", :params => %w(path to nowhere)).should be_true
    sleep 3.5
    c.cache_get("/cache_controller/action4/path/to/nowhere").should be_nil
    c.cached_action?(:action => "action4", :params => %w(path to nowhere)).should be_false
  end

  it "should expire action in many ways" do
    c = get("/cache_controller/action4")
    CACHE.expire_action("action4")
    CACHE.cached_action?("action4").should be_false

    c = get("/cache_controller/action4")
    CACHE.expire_action(:match => "/cache_control")
    CACHE.cached_action?(:action => "action4").should be_false

    c = get("/cache_controller/action4")
    CACHE.expire_action(:action => "action4")
    CACHE.cached_action?(:action => "action4").should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:action => "action4", :params => %w(id1 id2))
    CACHE.cached_action?(:action => "action4", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:action => "action4", :match => true)
    CACHE.cached_action?(:action => "action4", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4")
    CACHE.expire_action(:action => "action4", :controller => "cache_controller")
    CACHE.cached_action?(:action => "action4", :controller => "cache_controller").should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:action => "action4", :params => %w(id1), :match => true)
    CACHE.cached_action?(:action => "action4", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:action => "action4", :controller => "cache_controller", :match => true)
    CACHE.cached_action?(:action => "action4", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:action => "action4", :controller => "cache_controller", :params => %w(id1), :match => true)
    CACHE.cached_action?(:action => "action4", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:action => "action4", :controller => "cache_controller", :params => %w(id1 id2))
    CACHE.cached_action?(:action => "action4", :controller => "cache_controller", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4")
    CACHE.expire_action(:key => "/cache_controller/action4")
    CACHE.cached_action?(:key => "/cache_controller/action4").should be_false
    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:key => "/cache_controller/action4", :params => %w(id1 id2))
    CACHE.cached_action?(:key => "/cache_controller/action4", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:key => "/cache_controller/action4/id1", :match => true)
    CACHE.cached_action?(:key => "/cache_controller/action4/id1/id2").should be_false

    c = get("/cache_controller/action4/id1/id2")
    CACHE.expire_action(:key => "/cache_controller/action4", :params => %w(id1), :match => true)
    CACHE.cached_action?(:key => "/cache_controller/action4/id1/id2").should be_false
  end

end
