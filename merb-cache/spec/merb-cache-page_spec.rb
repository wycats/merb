describe "merb-cache-page" do

  it "should cache page (action5)" do
    c = get("/cache_controller/action5")
    c.body.strip.should == "test action5"
    c.cached_page?("action5").should be_true
  end

  it "should expire page (action5)" do
    CACHE.expire_page("action5")
    CACHE.cached_page?("action5").should be_false
  end

  it "should cache page (action5) with full path" do
    c = get("/cache_controller/action5/this/is/a/test")
    c.cached_page?(:action => "action5", :params => %w(this is a test)).should be_true
  end

  it "should expire page (action5) with full path" do
    CACHE.expire_page(:action => "action5",
                      :controller => "cache_controller",
                      :params => %w(this is a test))
    CACHE.cached_page?(:key => "/cache_controller/action5/this/is/a/test").should be_false
  end

  it "should cache page (action6), use it and expire 3 seconds after" do
    CACHE.expire_page :match => true, :action => "action6"
    c = get("/cache_controller/action6")
    now = Time.now.to_s
    c.body.strip.should == now
    c.cached_page?("action6").should be_true
    sleep 1
    c = get("/cache_controller/action6")
    c.body.strip.should == now
    sleep 2
    c = get("/cache_controller/action6")
    c.body.strip.should == Time.now.to_s
  end

  it "should cache page with full path (action6) and expire in 3 seconds" do
    CACHE.expire_page "action6"
    CACHE.cached_page?(:action => "action6", :params => %w(path to nowhere)).should be_false
    c = get("/cache_controller/action6/path/to/nowhere/")
    now = Time.now.to_s
    c.body.strip.should == now
    c.cached_page?(:action => "action6", :params => %w(path to nowhere)).should be_true
    sleep 1
    c = get("/cache_controller/action6/path/to/nowhere")
    c.body.strip.should == now
    sleep 2
    c = get("/cache_controller/action6/path/to/nowhere")
    c.body.strip.should == Time.now.to_s
  end

  it "should expire page using different ways" do
    c = get("/cache_controller/action6")
    CACHE.expire_page("action6")
    CACHE.cached_page?("action6").should be_false

    c = get("/cache_controller/action6")
    CACHE.expire_page(:match => "/cache_control")
    CACHE.cached_page?(:action => "action6").should be_false

    c = get("/cache_controller/action6")
    CACHE.expire_page(:action => "action6")
    CACHE.cached_page?(:action => "action6").should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:action => "action6", :params => %w(id1 id2))
    CACHE.cached_page?(:action => "action6", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:action => "action6", :match => true)
    CACHE.cached_page?(:action => "action6", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6")
    CACHE.expire_page(:action => "action6", :controller => "cache_controller")
    CACHE.cached_page?(:action => "action6", :controller => "cache_controller").should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:action => "action6", :params => %w(id1), :match => true)
    CACHE.cached_page?(:action => "action6", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:action => "action6", :controller => "cache_controller", :match => true)
    CACHE.cached_page?(:action => "action6", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:action => "action6", :controller => "cache_controller", :params => %w(id1), :match => true)
    CACHE.cached_page?(:action => "action6", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:action => "action6", :controller => "cache_controller", :params => %w(id1 id2))
    CACHE.cached_page?(:action => "action6", :controller => "cache_controller", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6")
    CACHE.expire_page(:key => "/cache_controller/action6")
    CACHE.cached_page?(:key => "/cache_controller/action6").should be_false
    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:key => "/cache_controller/action6", :params => %w(id1 id2))
    CACHE.cached_page?(:key => "/cache_controller/action6", :params => %w(id1 id2)).should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:key => "/cache_controller/action6/id1", :match => true)
    CACHE.cached_page?(:key => "/cache_controller/action6/id1/id2").should be_false

    c = get("/cache_controller/action6/id1/id2")
    CACHE.expire_page(:key => "/cache_controller/action6", :params => %w(id1), :match => true)
    CACHE.cached_page?(:key => "/cache_controller/action6/id1/id2").should be_false
  end

  it "should expire all pages" do
    CACHE.expire_all_pages
    CACHE.cached_page?("action6").should be_false
    Dir.glob(Merb::Controller._cache.config[:cache_html_directory] + '/*').should be_empty
  end

end
