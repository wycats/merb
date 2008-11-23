require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

Merb.start :environment => 'test', :log_level => :fatal

require File.dirname(__FILE__) / "controllers/request_controller"

describe Merb::Test::RequestHelper do
  
  before(:each) do
    Merb::Controller._default_cookie_domain = "example.org"
    
    Merb::Router.prepare do
      with(:controller => "merb/test/request_controller") do
        match("/set/short/long/read").to(:action => "get")
        match("/:action(/:junk)", :junk => ".*").register
      end
    end
  end
  
  it "should dispatch a request using GET by defalt" do
    request("/request_method").should have_body("Method - GET")
  end
  
  it "should work with have_selector" do
    request("/document").should have_selector("div div")
  end
  
  it "should work with have_xpath" do
    request("/document").should have_xpath("//div/div")
  end
  
  it "should work with have_content" do
    request("/request_method").should contain("Method")
  end
  
  it "should persist cookies across sequential cookie setting requests" do
    request("/counter").should have_body("1")
    request("/counter").should have_body("2")
  end
  
  it "should persist cookies across requests that don't return any cookie headers" do
    request("/counter").should have_body("1")
    request("/void").should    have_body("Void")
    request('/counter').should have_body("2")
  end
  
  it "should delete cookies from the jar" do
    request("/counter").should have_body("1")
    request("/delete").should  have_body("Delete")
    request("/counter").should have_body("1")
  end
  
  it "should be able to disable the cookie jar" do
    request("/counter", :jar => nil).should have_body("1")
    request("/counter", :jar => nil).should have_body("1")
    request("/counter").should have_body("1")
    request("/counter").should have_body("2")
  end
  
  it "should be able to specify separate jars" do
    request("/counter", :jar => :one).should have_body("1")
    request("/counter", :jar => :two).should have_body("1")
    request("/counter", :jar => :one).should have_body("2")
    request("/counter", :jar => :two).should have_body("2")
  end
  
  it "should respect cookie domains when no domain is explicitly set" do
    request("http://example.org/counter").should     have_body("1")
    request("http://www.example.org/counter").should have_body("2")
    request("http://example.org/counter").should     have_body("3")
    request("http://www.example.org/counter").should have_body("4")
  end
  
  it "should respect the domain set in the cookie" do
    request("http://example.org/domain").should     have_body("1")
    request("http://foo.example.org/domain").should have_body("1")
    request("http://example.org/domain").should     have_body("1")
    request("http://foo.example.org/domain").should have_body("2")
  end
  
  it "should respect the path set in the cookie" do
    request("/path").should      have_body("1")
    request("/path/zomg").should have_body("1")
    request("/path").should      have_body("1")
    request("/path/zomg").should have_body("2")
  end
  
  it "should use the most specific path cookie" do
    request("/set/short")
    request("/set/short/long")
    request("/set/short/long/read").should have_body("/set/short/long")
  end
  
  it "should use the most specific path cookie even if it was defined first" do
    request("/set/short/long")
    request("/set/short")
    request("/set/short/long/read").should have_body("/set/short/long")
  end
  
  it "should leave the least specific cookie intact when specifying a more specific path" do
    request("/set/short")
    request("/set/short/long/zomg/what/hi")
    request("/set/short/long/read").should have_body("/set/short")
  end
  
  it "should use the most specific domain cookie" do
    request("http://test.com/domain_set")
    request("http://one.test.com/domain_set")
    request("http://one.test.com/domain_get").should have_body("one.test.com")
  end
  
  it "should keep the less specific domain cookie" do
    request("http://test.com/domain_set").should be_successful
    request("http://one.test.com/domain_set").should be_successful
    request("http://test.com/domain_get").should have_body("test.com")
  end
  
  it "should respect the expiration" do
    request("/expires").should have_body("1")
    sleep(1)
    request("/expires").should have_body("1")
  end
  
end